import 'package:drift/drift.dart';

class SleepEntries extends Table {
  TextColumn get id => text()();
  IntColumn get startTime => integer()(); // Epoch milliseconds
  IntColumn get endTime => integer()();
  IntColumn get duration => integer()(); // In minutes
  IntColumn get qualityScore => integer().nullable()(); // 0-100
  IntColumn get interruptions => integer().withDefault(const Constant(0))();
  TextColumn get source => text()(); // 'manual', 'health_connect', 'sleep_as_android'

  @override
  Set<Column> get primaryKey => {id};
}
