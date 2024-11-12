import 'package:flutter/material.dart';
import 'wordlist_screen.dart';

class DetailScreen extends StatelessWidget {
  final String wordSetTitle;

  const DetailScreen({
    required this.wordSetTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(wordSetTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WordListScreen()));
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
                color: Colors.red,
                width: double.infinity,
                child: const Center(
                  child: Text(
                    'apple',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              child: const Center(
                child: Text(
                  '사과',
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
                        // print('정답확인 버튼이 눌렸습니다');
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
                    color: Colors.brown,
                    child: InkWell(
                      onTap: () {
                        // print('암기완료 버튼이 눌렸습니다');
                      },
                      child: const Center(
                        child: Text(
                          '암기완료',
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
                    color: Colors.orange,
                    child: InkWell(
                      onTap: () {
                        // print('다음 버튼이 눌렸습니다');
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
