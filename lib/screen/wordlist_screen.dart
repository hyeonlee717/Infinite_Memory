import 'package:flutter/material.dart';
import '../models/word_set.dart';

class WordListScreen extends StatefulWidget {
  final WordSet wordSet;

  const WordListScreen({required this.wordSet, super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  void _showAddWordDialog(BuildContext context) {
    final TextEditingController englishController = TextEditingController();
    final TextEditingController meaningController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('단어 추가'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: englishController,
                decoration: const InputDecoration(labelText: '영어 단어'),
              ),
              TextField(
                controller: meaningController,
                decoration: const InputDecoration(labelText: '의미'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (englishController.text.isNotEmpty &&
                    meaningController.text.isNotEmpty) {
                  setState(
                    () {
                      widget.wordSet.addWord(
                        Word(
                          english: englishController.text,
                          label: widget.wordSet.words.length + 1,
                          meaning: meaningController.text,
                          memorized: false,
                        ),
                      );
                    },
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        title: const Text('단어 목록'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showAddWordDialog(context);
            },
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          border: TableBorder.all(color: Colors.grey, width: 0.5),
          columnWidths: {
            0: FixedColumnWidth(screenWidth * 0.15), // 전체 너비의 10%로 설정
            1: FixedColumnWidth(screenWidth * 0.35), // 전체 너비의 30%로 설정
            2: FixedColumnWidth(screenWidth * 0.35), // 전체 너비의 40%로 설정
            3: FixedColumnWidth(screenWidth * 0.15), // 전체 너비의 20%로 설정
          },
          children: [
            // 헤더
            const TableRow(
              children: [
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '라벨',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '영어 단어',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '의미',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '완료',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 데이터 행
            for (var word in widget.wordSet.words)
              TableRow(
                children: [
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          word.label.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          word.english,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          word.meaning,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(word.memorized ? Icons.check : Icons.close,
                            color: word.memorized ? Colors.green : Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
