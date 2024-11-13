import 'package:flutter/material.dart';
import 'wordlist_screen.dart';
import '../models/word_set.dart';
import 'dart:math';

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
  late Word currentWord;
  final Random _random = Random();
  bool showMeaning = false;

  @override
  void initState() {
    super.initState();
    _loadRandomWord();
  }

  void _loadRandomWord() {
    List<Word> availableWords =
        widget.wordSet.words.where((word) => !word.memorized).toList();
    if (availableWords.isNotEmpty) {
      setState(() {
        currentWord = availableWords[_random.nextInt(availableWords.length)];
        showMeaning = false; // 의미를 숨김
      });
    } else {
      // 모든 단어가 암기 완료된 경우 처리
      setState(() {
        currentWord = Word(
          english: '',
          label: 0,
          meaning: '',
          memorized: false,
        );
      });
    }
  }

  void _markAsMemorized() {
    setState(() {
      currentWord.memorized = true;
      // 업데이트된 단어를 Hive에 저장
      widget.wordSet.save();
      _loadRandomWord(); // 다음 단어 로드
    });
  }

  void _showMeaning() {
    setState(() {
      showMeaning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 단어가 없을 경우 표시할 위젯
    if (widget.wordSet.words.isEmpty ||
        currentWord.english.isEmpty && currentWord.meaning.isEmpty) {
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
            '등록된 단어가 없습니다.',
            style: TextStyle(fontSize: 18),
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
                  currentWord.english,
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
                        currentWord.meaning,
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
                    color: currentWord.memorized ? Colors.grey : Colors.brown,
                    child: InkWell(
                      onTap: currentWord.memorized
                          ? null
                          : () {
                              _markAsMemorized();
                            },
                      child: Center(
                        child: Text(
                          currentWord.memorized ? '암기완료!' : '암기완료 변경',
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
