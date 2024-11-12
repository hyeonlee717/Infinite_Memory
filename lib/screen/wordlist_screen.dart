import 'package:flutter/material.dart';

class WordListScreen extends StatelessWidget {
  const WordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 예시 데이터
    final List<Map<String, dynamic>> words = [
      {'label': 1, 'english': 'apple', 'meaning': '사과', 'memorized': true},
      {'label': 2, 'english': 'banana', 'meaning': '바나나', 'memorized': false},
      {'label': 3, 'english': 'cherry', 'meaning': '체리', 'memorized': true},
      // 추가 데이터...
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 목록'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('라벨'),
            ),
            DataColumn(
              label: Text('영어 단어'),
            ),
            DataColumn(
              label: Text('뜻'),
            ),
            DataColumn(
              label: Text('암기 완료'),
            ),
          ],
          rows: words.map((word) {
            return DataRow(cells: [
              DataCell(Align(
                alignment: Alignment.center,
                child: Text(word['label'].toString()),
              )),
              DataCell(Align(
                alignment: Alignment.center,
                child: Text(word['english']),
              )),
              DataCell(Align(
                alignment: Alignment.center,
                child: Text(word['meaning']),
              )),
              DataCell(Align(
                alignment: Alignment.center,
                child: Icon(
                  word['memorized'] ? Icons.check : Icons.close,
                  color: word['memorized'] ? Colors.green : Colors.red,
                ),
              )),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
