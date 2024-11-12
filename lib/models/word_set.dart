import 'package:hive/hive.dart';

part 'word_set.g.dart';

@HiveType(typeId: 0)
class WordSet extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int repeatCount;

  @HiveField(2)
  List<Word> words;

  WordSet({
    required this.title,
    required this.repeatCount,
    required this.words,
  });

  void addWord(Word word) {
    words.add(word);
    save();
  }
}

@HiveType(typeId: 1)
class Word extends HiveObject {
  @HiveField(0)
  String english;

  @HiveField(1)
  int label;

  @HiveField(2)
  String meaning;

  @HiveField(3)
  bool memorized;

  Word({
    required this.english,
    required this.label,
    required this.meaning,
    required this.memorized,
  });
}
