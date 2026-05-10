import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../../core/database/database.dart';
import '../../core/database/tables/journal_tables.dart';

// Provider for the database instance
final dbProvider = Provider<AppDatabase>((ref) {
  return AppDatabase(); // In a real app, this should be a singleton managed at the app level
});

// Stream provider to get all journal entries, sorted by date
final journalEntriesProvider = StreamProvider<List<JournalEntry>>((ref) {
  final db = ref.watch(dbProvider);
  return (db.select(db.journalEntries)
        ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
      .watch();
});

class JournalService {
  final AppDatabase db;
  JournalService(this.db);

  Future<void> saveEntry({
    required String date,
    required String content,
    int? moodScore,
    int? productivityScore,
    String? tags,
  }) async {
    // Generate a unique ID (e.g., UUID, or simply use the date if it's 1 per day)
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    await db.into(db.journalEntries).insertOnConflictUpdate(
      JournalEntriesCompanion.insert(
        id: id,
        date: date,
        content: content,
        moodScore: Value(moodScore),
        productivityScore: Value(productivityScore),
        tags: Value(tags),
      ),
    );
  }

  Future<void> deleteEntry(String id) async {
    await (db.delete(db.journalEntries)..where((t) => t.id.equals(id))).go();
  }
}

final journalServiceProvider = Provider<JournalService>((ref) {
  return JournalService(ref.watch(dbProvider));
});
