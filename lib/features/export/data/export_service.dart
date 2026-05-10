import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/database/database.dart';

class ExportService {
  final AppDatabase db;

  ExportService(this.db);

  /// Exports all journal entries to a JSON file and opens the share sheet.
  Future<void> exportData() async {
    try {
      // 1. Fetch data from DB
      final journals = await db.select(db.journalEntries).get();
      final screenTime = await db.select(db.dailyAppUsage).get();
      final activity = await db.select(db.dailyActivity).get();

      // 2. Structure into a massive JSON map
      final exportData = {
        "export_date": DateTime.now().toIso8601String(),
        "journals": journals.map((j) => {
          "id": j.id,
          "date": j.date,
          "content": j.content,
          "moodScore": j.moodScore,
        }).toList(),
        "activity": activity.map((a) => {
          "date": a.date,
          "steps": a.steps,
          "activeMinutes": a.activeMinutes,
        }).toList(),
        "screen_time": screenTime.map((s) => {
          "date": s.date,
          "appPackage": s.appPackage,
          "totalTime": s.totalTime,
        }).toList(),
      };

      // 3. Write to temporary local file
      final directory = await getTemporaryDirectory();
      final file = File('\${directory.path}/life_os_backup.json');
      await file.writeAsString(jsonEncode(exportData));

      // 4. Trigger the native Share Sheet so the user can save it to Drive/Files
      await Share.shareXFiles([XFile(file.path)], text: 'LifeOS Backup');
      
    } catch (e) {
      print("Export failed: \$e");
    }
  }
}
