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
    // setState(() {});

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
    int byteCount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  'Add a new wordset',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Wordset Title',
                  counterText: '$byteCount/24',
                ),
                maxLength: 24,
                onChanged: (text) {
                  int count = 0;
                  for (int rune in text.runes) {
                    if (rune <= 0x7F) {
                      count += 1; // 영어
                    } else {
                      count += 2; // 한글
                    }
                  }

                  if (count > 24) {
                    // 최대 바이트 초과 시
                    String newText = '';
                    int currentCount = 0;
                    for (int rune in text.runes) {
                      int charCount = (rune <= 0x7F) ? 1 : 2;
                      if (currentCount + charCount > 24) break;
                      newText += String.fromCharCode(rune);
                      currentCount += charCount;
                    }
                    controller.text = newText;
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                    count = currentCount;
                  }

                  setState(() {
                    byteCount = count;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      _addWordSet(controller.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.menu, size: 30),
        // ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Infinite Memory',
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
        padding: const EdgeInsets.only(top: 12, bottom: 36),
        itemCount: wordSetBox.length,
        itemBuilder: (context, index) {
          final actualIndex = wordSetBox.length - 1 - index;
          final wordSet = wordSetBox.getAt(actualIndex);
          if (wordSet == null) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Dismissible(
              key: Key(wordSet.key.toString()),
              direction: DismissDirection.startToEnd,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(40),
                      content: const Text(
                        'Delete this wordset?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // 취소
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            wordSetBox.delete(wordSet.key);
                            Navigator.of(context).pop(true); // 확인
                          },
                          child: const Text(
                            'Yes',
                            style: TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                // 항목이 삭제된 후 상태를 업데이트
                setState(() {
                  // 리스트에서 항목을 제거하는 로직 추가
                });
              },
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        wordSet: wordSet,
                        wordSetTitle: wordSet.title,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.indigo[900],
                    width: double.infinity,
                    height: 120,
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            wordSet.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 10,
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.keyboard_double_arrow_right_outlined,
                                  color: Colors.white70,
                                  size: 10,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
