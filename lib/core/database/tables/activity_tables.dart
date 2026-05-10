import 'package:drift/drift.dart';

class DailyActivity extends Table {
  TextColumn get date => text()(); // Format: YYYY-MM-DD
  IntColumn get steps => integer().withDefault(const Constant(0))();
  IntColumn get activeMinutes => integer().withDefault(const Constant(0))();
  RealColumn get distanceMeters => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {date};
}
