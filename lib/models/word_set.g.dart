// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WordSetAdapter extends TypeAdapter<WordSet> {
  @override
  final int typeId = 0;

  @override
  WordSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordSet(
      title: fields[0] as String,
      repeatCount: fields[1] as int,
      words: (fields[2] as List).cast<Word>(),
    );
  }

  @override
  void write(BinaryWriter writer, WordSet obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.repeatCount)
      ..writeByte(2)
      ..write(obj.words);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WordAdapter extends TypeAdapter<Word> {
  @override
  final int typeId = 1;

  @override
  Word read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Word(
      english: fields[0] as String,
      label: fields[1] as int,
      meaning: fields[2] as String,
      memorized: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Word obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.english)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.meaning)
      ..writeByte(3)
      ..write(obj.memorized);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
