import 'package:drift/drift.dart';

class JournalEntries extends Table {
  TextColumn get id => text()();
  TextColumn get date => text().unique()(); // Format: YYYY-MM-DD
  TextColumn get content => text()();
  IntColumn get moodScore => integer().nullable()(); // 1-5 or 1-10
  IntColumn get productivityScore => integer().nullable()();
  TextColumn get tags => text().nullable()(); // JSON array string of tags

  @override
  Set<Column> get primaryKey => {id};
}
