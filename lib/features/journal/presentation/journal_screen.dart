import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/journal_provider.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _contentController = TextEditingController();
  double _moodScore = 3.0;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    final today = DateTime.now();
    final dateString = "\${today.year}-\${today.month.toString().padLeft(2, '0')}-\${today.day.toString().padLeft(2, '0')}";

    ref.read(journalServiceProvider).saveEntry(
      date: dateString,
      content: content,
      moodScore: _moodScore.toInt(),
    );

    _contentController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Journal entry saved offline.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(journalEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Journal")),
      body: SafeArea(
        child: Column(
          children: [
            _buildEditor(),
            const Divider(color: Color(0xFF1E1E1E), thickness: 2),
            Expanded(
              child: entriesAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return const Center(child: Text("No entries yet.", style: TextStyle(color: Colors.grey)));
                  }
                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return ListTile(
                        title: Text(entry.date, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(entry.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.mood, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(entry.moodScore?.toString() ?? '-'),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text("Error loading entries: \$e")),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _contentController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              filled: true,
              fillColor: const Color(0xFF121212),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Mood: ', style: TextStyle(color: Colors.grey)),
              Expanded(
                child: Slider(
                  value: _moodScore,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: const Color(0xFF00F0FF),
                  label: _moodScore.toInt().toString(),
                  onChanged: (val) => setState(() => _moodScore = val),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D00FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveEntry,
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
