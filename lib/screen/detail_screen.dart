import 'package:flutter/material.dart';
import 'wordlist_screen.dart';
import '../models/word_set.dart';
import 'dart:math';
import 'dart:async';
import 'package:hive/hive.dart';

class DetailScreen extends StatefulWidget {
  final String wordSetTitle;
  final WordSet wordSet;

  const DetailScreen({
    required this.wordSetTitle,
    required this.wordSet,
    super.key,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Word? currentWord;
  final Random _random = Random();
  bool isShowingMeaning = false; // 단일 상태 변수: 모드 관리
  bool showWord = false; // 단어 표시 상태 변수: 정답확인 버튼 관리
  late StreamSubscription<BoxEvent> _subscription;
  List<Word> previouslySelectedWords = [];

  @override
  void initState() {
    super.initState();
    _loadRandomWord();
    final box = Hive.box<WordSet>('wordSets');
    _subscription = box.watch().listen((event) {
      _loadRandomWord();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _loadRandomWord() {
    // 외우지 못한 모든 단어 목록
    List<Word> notMemorizedWords =
        widget.wordSet.words.where((word) => !word.memorized).toList();

    if (notMemorizedWords.isEmpty) {
      // 모든 단어가 암기 완료된 경우
      setState(() {
        currentWord = null;
      });
      return;
    }

    // 이전에 선택된 단어를 제외한 단어 목록
    List<Word> availableWords = notMemorizedWords
        .where((word) => !previouslySelectedWords.contains(word))
        .toList();

    if (availableWords.isEmpty) {
      // 모든 외우지 못한 단어를 한 번씩 보여준 경우 이전 선택 목록 초기화
      previouslySelectedWords.clear();
      availableWords = notMemorizedWords;
    }

    setState(() {
      currentWord = availableWords[_random.nextInt(availableWords.length)];
      previouslySelectedWords.add(currentWord!); // 선택된 단어 추가
      showWord = false; // 단어 표시 상태 초기화
    });
  }

  void _markAsMemorized() {
    if (currentWord != null) {
      setState(() {
        currentWord!.memorized = true;
        widget.wordSet.save();
        _loadRandomWord(); // 다음 단어 로드
      });
    }
  }

  void _showMeaning() {
    setState(() {
      showWord = true; // 단어와 의미를 동시에 표시
    });
  }

  Widget _buildWordDisplay() {
    if (!isShowingMeaning || showWord) {
      return Text(
        currentWord!.english,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const SizedBox.shrink(); // 필요 없을 경우 숨김
    }
  }

  Widget _buildMeaningDisplay() {
    if (isShowingMeaning || showWord) {
      return Text(
        currentWord!.meaning,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const SizedBox.shrink(); // 필요 없을 경우 숨김
    }
  }

  double _calculateMemorizedPercentage() {
    if (widget.wordSet.words.isEmpty) return 0; // 단어가 없을 경우 0%
    int memorizedCount =
        widget.wordSet.words.where((word) => word.memorized).length; // 암기된 단어 수
    return (memorizedCount / widget.wordSet.words.length) * 100;
  }

  int _getMemorizedCount() {
    return widget.wordSet.words
        .where((word) => word.memorized)
        .length; // 암기된 단어 수
  }

  @override
  Widget build(BuildContext context) {
    // 단어가 없을 경우 표시할 위젯
    if (currentWord == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.black,
          centerTitle: true,
          title: Text(
            widget.wordSetTitle,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          actions: [
            const SizedBox(width: 5),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WordListScreen(wordSet: widget.wordSet),
                  ),
                );
              },
              icon: const Icon(Icons.view_list, size: 30),
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'Add a new word to memorize',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.wordSetTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isShowingMeaning = !isShowingMeaning; // 상태 토글
                showWord = false; // 정해진 모드에 따라 단어 표시 상태 초기화
              });
            },
            icon: Icon(
              Icons.change_circle_outlined,
              size: 30,
              color: isShowingMeaning
                  ? Colors.blueAccent
                  : Colors.redAccent, // 상태에 따른 색상 변경
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordListScreen(wordSet: widget.wordSet),
                ),
              );
            },
            icon: const Icon(Icons.view_list, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  '${_calculateMemorizedPercentage().toInt()}%            ${_getMemorizedCount()}/${widget.wordSet.words.length}', // 비율 및 총 단어 수 표시
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.redAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: _buildWordDisplay(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.blueAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: _buildMeaningDisplay(),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.green,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () {
                          _showMeaning();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Answer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.brown,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () {
                          _markAsMemorized();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Marked!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      color: Colors.orange,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () {
                          _loadRandomWord();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
