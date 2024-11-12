import 'package:flutter/material.dart';

class WordListScreen extends StatelessWidget {
  const WordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면 크기 정보 가져오기
    double screenWidth = MediaQuery.of(context).size.width;

    // 예시 데이터
    final List<Map<String, dynamic>> words = [
      {
        'label': 1,
        'english': 'appleeeeeeeeeeee',
        'meaning': '사과',
        'memorized': true
      },
      {'label': 2, 'english': 'banana', 'meaning': '바나나', 'memorized': false},
      {'label': 3, 'english': 'cherry', 'meaning': '체리', 'memorized': true},
      {'label': 4, 'english': 'date', 'meaning': '대추야자', 'memorized': false},
      {
        'label': 5,
        'english': 'elderberry',
        'meaning': '엘더베리',
        'memorized': true
      },
      {'label': 6, 'english': 'fig', 'meaning': '무화과', 'memorized': false},
      {'label': 7, 'english': 'grape', 'meaning': '포도', 'memorized': true},
      {'label': 8, 'english': 'honeydew', 'meaning': '허니듀', 'memorized': false},
      {'label': 9, 'english': 'kiwi', 'meaning': '키위', 'memorized': true},
      {'label': 10, 'english': 'lemon', 'meaning': '레몬', 'memorized': false},
      {'label': 11, 'english': 'mango', 'meaning': '망고', 'memorized': true},
      {
        'label': 12,
        'english': 'nectarine',
        'meaning': '넥타린',
        'memorized': false
      },
      {'label': 13, 'english': 'orange', 'meaning': '오렌지', 'memorized': true},
      {'label': 14, 'english': 'papaya', 'meaning': '파파야', 'memorized': false},
      {'label': 15, 'english': 'quince', 'meaning': '모과', 'memorized': true},
      {
        'label': 16,
        'english': 'raspberry',
        'meaning': '라즈베리',
        'memorized': false
      },
      {
        'label': 17,
        'english': 'strawberry',
        'meaning': '딸기',
        'memorized': true
      },
      {'label': 18, 'english': 'tangerine', 'meaning': '귤', 'memorized': false},
      {
        'label': 19,
        'english': 'ugli fruit',
        'meaning': '우글리 과일',
        'memorized': true
      },
      {'label': 20, 'english': 'vanilla', 'meaning': '바닐라', 'memorized': false},
      {
        'label': 21,
        'english': 'watermelon',
        'meaning': '수박',
        'memorized': true
      },
      {'label': 22, 'english': 'xigua', 'meaning': '시과', 'memorized': false},
      {
        'label': 23,
        'english': 'yellow passion fruit',
        'meaning': '노란 패션프루트',
        'memorized': true
      },
      {
        'label': 24,
        'english': 'zucchini',
        'meaning': '주키니',
        'memorized': false
      },
      {'label': 25, 'english': 'apricot', 'meaning': '살구', 'memorized': true},
      {
        'label': 26,
        'english': 'blackberry',
        'meaning': '블랙베리',
        'memorized': false
      },
      {
        'label': 27,
        'english': 'cantaloupe',
        'meaning': '칸탈루프',
        'memorized': true
      },
      {
        'label': 28,
        'english': 'dragonfruit',
        'meaning': '용과',
        'memorized': false
      },
      {
        'label': 29,
        'english': 'elderflower',
        'meaning': '엘더플라워',
        'memorized': true
      },
      {'label': 30, 'english': 'fig', 'meaning': '무화과', 'memorized': false},
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        title: const Text('단어 목록'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
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
            for (var word in words)
              TableRow(
                children: [
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          word['label'].toString(),
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
                          word['english'],
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
                          word['meaning'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                            word['memorized'] ? Icons.check : Icons.close,
                            color:
                                word['memorized'] ? Colors.green : Colors.red),
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
