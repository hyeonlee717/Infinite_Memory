import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/word_set.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> wordSets = [];
  late Box<WordSet> wordSetBox;

  @override
  void initState() {
    super.initState();
    wordSetBox = Hive.box<WordSet>('wordSets');

    // 기존 데이터 삭제 (개발 중에만 사용)
    // wordSetBox.clear();
  }

  void _addWordSet(String title) {
    final newWordSet = WordSet(
      title: title,
      repeatCount: 0,
      words: [],
    );
    wordSetBox.add(newWordSet);
    setState(() {});
  }

  void _showAddWordSetDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            padding: const EdgeInsets.only(top: 30),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: '단어장 제목'),
            ),
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
                if (controller.text.isNotEmpty) {
                  _addWordSet(controller.text);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 30),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        title: const Text(
          '단어장 목록',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showAddWordSetDialog,
            icon: const Icon(Icons.add),
            iconSize: 30,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: wordSetBox.length,
        itemBuilder: (context, index) {
          final wordSet = wordSetBox.getAt(index);
          if (wordSet == null) {
            return const SizedBox.shrink();
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(wordSetTitle: wordSet.title),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey, // 원하는 색상 지정
                  borderRadius: BorderRadius.circular(20),
                ),
                width: double.infinity,
                height: 150,
                child: Center(
                  child: Text(
                    wordSet.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
