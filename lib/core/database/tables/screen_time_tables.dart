import 'package:drift/drift.dart';

class ScreenSessions extends Table {
  TextColumn get id => text()();
  TextColumn get appPackage => text()();
  IntColumn get startTime => integer()();
  IntColumn get endTime => integer()();
  IntColumn get duration => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class DailyAppUsage extends Table {
  TextColumn get date => text()(); // Format: YYYY-MM-DD
  TextColumn get appPackage => text()();
  IntColumn get totalTime => integer()();
  IntColumn get unlocks => integer()();

  @override
  Set<Column> get primaryKey => {date, appPackage};
}
