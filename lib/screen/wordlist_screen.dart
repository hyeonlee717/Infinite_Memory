import 'package:flutter/material.dart';
import '../models/word_set.dart';

class WordListScreen extends StatefulWidget {
  final WordSet wordSet;

  const WordListScreen({required this.wordSet, super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  List<bool> _selectedWords = []; // 선택된 단어를 추적하는 리스트
  bool _isDeletingMode = false; // 삭제 모드 상태 변수 추가

  @override
  void initState() {
    super.initState();
    _selectedWords =
        List<bool>.filled(widget.wordSet.words.length, false); // 초기화
  }

  void _toggleSelection(int index) {
    setState(() {
      _selectedWords[index] = !_selectedWords[index]; // 선택 상태 토글
    });
  }

  void _deleteSelectedWords() {
    setState(() {
      if (widget.wordSet.words.isNotEmpty) {
        // 리스트가 비어있지 않은지 확인
        widget.wordSet.words.removeWhere((word) =>
            _selectedWords[widget.wordSet.words.indexOf(word)]); // 선택된 단어 삭제
        // 삭제 후 라벨 재정렬
        for (int i = 0; i < widget.wordSet.words.length; i++) {
          widget.wordSet.words[i].label = i + 1; // 라벨을 1부터 순서대로 재설정
        }
        _selectedWords =
            List<bool>.filled(widget.wordSet.words.length, false); // 초기화
      }
      widget.wordSet.save(); // 변경 사항 저장
      _isDeletingMode = false; // 삭제 모드 종료
    });
  }

  void _showAddWordDialog(BuildContext context) {
    final TextEditingController englishController = TextEditingController();
    final TextEditingController meaningController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Add a new word',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: englishController,
                decoration: const InputDecoration(labelText: 'Word'),
              ),
              TextField(
                controller: meaningController,
                decoration: const InputDecoration(labelText: 'Meaning'),
              ),
            ],
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
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.redAccent),
              ),
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
        title: const Text('Word List'),
        centerTitle: true,
        actions: [
          if (_isDeletingMode) // 삭제 모드일 때만 삭제 버튼 표시
            TextButton(
              onPressed: _deleteSelectedWords,
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            )
          else // 삭제 모드가 아닐 때만 편집 아이콘 표시
            IconButton(
              onPressed: () {
                // 팝업 메뉴를 보여줍니다.
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(
                      100.0, 100.0, 0.0, 0.0), // 위치 조정
                  items: [
                    const PopupMenuItem(
                      value: 'add',
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Add'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('Delete'),
                      ),
                    ),
                  ],
                ).then((value) {
                  if (value == 'add') {
                    _showAddWordDialog(context); // 추가 다이얼로그 호출
                  } else if (value == 'delete') {
                    setState(() {
                      // 삭제 모드로 전환
                      _isDeletingMode = true; // 삭제 모드 상태 변수 추가
                      _selectedWords = List<bool>.filled(
                          widget.wordSet.words.length, false); // 초기화
                    });
                  }
                });
              },
              icon: const Icon(Icons.edit, size: 30),
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
                        'No.',
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
                        'Word',
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
                        'Meaning',
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
                        'Mark',
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
            for (var index = 0; index < widget.wordSet.words.length; index++)
              TableRow(
                children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isDeletingMode // 삭제 모드일 때 체크박스 표시
                            ? Checkbox(
                                value: _selectedWords[index],
                                onChanged: (value) {
                                  _toggleSelection(index); // 체크 상태 토글
                                },
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                              )
                            : Text(
                                widget.wordSet.words[index].label.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.wordSet.words[index].english,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.wordSet.words[index].meaning,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            widget.wordSet.words[index].memorized =
                                !widget.wordSet.words[index].memorized; // 상태 반전
                            widget.wordSet.save(); // 변경 사항 저장
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          child: Icon(
                            widget.wordSet.words[index].memorized
                                ? Icons.check
                                : Icons.close,
                            color: widget.wordSet.words[index].memorized
                                ? Colors.green
                                : Colors.red,
                            size: 20,
                          ),
                        ),
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
