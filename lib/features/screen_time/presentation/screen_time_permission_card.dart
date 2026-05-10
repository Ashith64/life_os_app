import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/screen_time_provider.dart';

class ScreenTimePermissionCard extends ConsumerWidget {
  const ScreenTimePermissionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPermission = ref.watch(screenTimePermissionProvider);

    if (hasPermission) {
      return const SizedBox.shrink(); // Hide if already granted
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Slightly lighter than background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF9D00FF).withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.privacy_tip, color: Color(0xFF9D00FF), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Unlock Screen Time Insights',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Grant Usage Access to track your digital habits securely on-device. LifeOS works 100% offline.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9D00FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                ref.read(screenTimePermissionProvider.notifier).requestPermission();
              },
              child: const Text('Grant Permission', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
