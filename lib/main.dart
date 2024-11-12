import 'package:flutter/material.dart';
import 'screen/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/word_set.dart';

void main() async {
  await Hive.initFlutter(); // Hive 초기화

  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(WordSetAdapter());

  // 모든 박스 삭제 (개발 중에만 사용, 실제 배포 시 제거)
  // await Hive.deleteBoxFromDisk('wordSets');

  await Hive.openBox<WordSet>('wordSets');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
