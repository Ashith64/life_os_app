import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/screen_time_repository.dart';

// Provider to manage the screen time permission state
final screenTimePermissionProvider = StateNotifierProvider<ScreenTimePermissionNotifier, bool>((ref) {
  return ScreenTimePermissionNotifier(ref.watch(screenTimeRepositoryProvider));
});

class ScreenTimePermissionNotifier extends StateNotifier<bool> {
  final ScreenTimeRepository _repository;

  ScreenTimePermissionNotifier(this._repository) : super(false) {
    checkPermission();
  }

  Future<void> checkPermission() async {
    final hasPermission = await _repository.checkUsagePermission();
    state = hasPermission;
  }

  Future<void> requestPermission() async {
    await _repository.requestUsagePermission();
    // After returning from settings, we check again
    await Future.delayed(const Duration(seconds: 2));
    await checkPermission();
  }
}

// Provider to fetch today's screen time stats directly from native
final todayScreenTimeProvider = FutureProvider<Map<String, int>>((ref) async {
  final repository = ref.watch(screenTimeRepositoryProvider);
  final hasPermission = ref.watch(screenTimePermissionProvider);
  
  if (!hasPermission) return {};
  
  return await repository.getDailyUsageStats(DateTime.now());
});
