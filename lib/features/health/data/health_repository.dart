import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:drift/drift.dart';
import '../../core/database/database.dart';
import '../../core/database/tables/activity_tables.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository(AppDatabase()); // Using the DB instance
});

class HealthRepository {
  final AppDatabase db;
  HealthRepository(this.db);

  // Initialize the health factory
  final HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  // Types of data we want to read
  final types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.SLEEP_SESSION,
  ];

  Future<bool> requestPermissions() async {
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];
    bool? hasPermissions = await health.hasPermissions(types, permissions: permissions);
    if (hasPermissions != true) {
      return await health.requestAuthorization(types, permissions: permissions);
    }
    return true;
  }

  Future<void> syncDailySteps(DateTime date) async {
    final hasPerms = await requestPermissions();
    if (!hasPerms) return;

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    int? steps = await health.getTotalStepsInInterval(startOfDay, endOfDay);
    
    if (steps != null && steps > 0) {
      final dateString = "\${date.year}-\${date.month.toString().padLeft(2, '0')}-\${date.day.toString().padLeft(2, '0')}";
      
      // Save directly to our local Drift DB
      await db.into(db.dailyActivity).insertOnConflictUpdate(
        DailyActivityCompanion.insert(
          date: dateString,
          steps: Value(steps),
        ),
      );
    }
  }
}
