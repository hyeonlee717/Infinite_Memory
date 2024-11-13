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
  bool showMeaning = false;
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
      showMeaning = false; // 의미를 숨김
      previouslySelectedWords.add(currentWord!); // 선택된 단어 추가
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
      showMeaning = true;
    });
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
            '외우지 못한 단어가 더이상 없습니다.',
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
            onPressed: () {},
            icon: const Icon(Icons.change_circle_outlined, size: 30),
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
            flex: 3,
            child: Container(
              color: Colors.redAccent,
              width: double.infinity,
              child: Center(
                child: Text(
                  currentWord!.english,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blueAccent,
              width: double.infinity,
              child: Center(
                child: showMeaning
                    ? Text(
                        currentWord!.meaning,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Material(
                    color: Colors.green,
                    child: InkWell(
                      onTap: () {
                        _showMeaning();
                      },
                      child: const Center(
                        child: Text(
                          '정답확인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Material(
                    color: currentWord!.memorized ? Colors.grey : Colors.brown,
                    child: InkWell(
                      onTap: currentWord!.memorized
                          ? null
                          : () {
                              _markAsMemorized();
                            },
                      child: Center(
                        child: Text(
                          currentWord!.memorized ? '암기완료!!' : '암기완료',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Material(
                    color: Colors.orange,
                    child: InkWell(
                      onTap: () {
                        _loadRandomWord();
                      },
                      child: const Center(
                        child: Text(
                          '다음',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
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
