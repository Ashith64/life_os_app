import 'package:workmanager/workmanager.dart';
import '../database/database.dart';
import '../../features/screen_time/data/screen_time_repository.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == 'syncScreenTimeTask') {
        // Since we are in an isolate, we need to instantiate repository and database
        final repository = ScreenTimeRepositoryImpl();
        final db = AppDatabase();
        
        final hasPermission = await repository.checkUsagePermission();
        if (!hasPermission) return true; // Fail silently if no permission
        
        final today = DateTime.now();
        final usageMap = await repository.getDailyUsageStats(today);
        
        final dateString = "\${today.year}-\${today.month.toString().padLeft(2, '0')}-\${today.day.toString().padLeft(2, '0')}";
        
        // Insert into Drift DB
        for (var entry in usageMap.entries) {
          final packageName = entry.key;
          final durationMs = entry.value;
          
          await db.into(db.dailyAppUsage).insertOnConflictUpdate(
            DailyAppUsageCompanion.insert(
              date: dateString,
              appPackage: packageName,
              totalTime: durationMs,
              unlocks: 0, // Unlocks are harder to track purely via UsageStatsManager, usually requires broadcast receivers
            ),
          );
        }
        
        await db.close();
      }
      return true;
    } catch (e) {
      print("WorkManager Task Failed: \$e");
      return false;
    }
  });
}

class WorkManagerService {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> registerScreenTimeSync() async {
    await Workmanager().registerPeriodicTask(
      "1",
      "syncScreenTimeTask",
      frequency: const Duration(hours: 1), // Poll every hour
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: true, // Respect device battery
      ),
    );
  }
}
