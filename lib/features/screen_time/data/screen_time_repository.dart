import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provides the repository
final screenTimeRepositoryProvider = Provider<ScreenTimeRepository>((ref) {
  return ScreenTimeRepositoryImpl();
});

abstract class ScreenTimeRepository {
  /// Fetches daily usage stats for all apps from the native Android side.
  /// Returns a map of package names to duration in milliseconds.
  Future<Map<String, int>> getDailyUsageStats(DateTime date);
  
  /// Checks if the usage stats permission is granted.
  Future<bool> checkUsagePermission();
  
  /// Opens the settings page for the user to grant usage stats permission.
  Future<void> requestUsagePermission();
}

class ScreenTimeRepositoryImpl implements ScreenTimeRepository {
  static const MethodChannel _channel = MethodChannel('com.lifeos.app/usage_stats');

  @override
  Future<Map<String, int>> getDailyUsageStats(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
      final endOfDay = startOfDay + 86400000; // + 1 day in ms

      final result = await _channel.invokeMethod<Map<Object?, Object?>>('getUsageStats', {
        'startTime': startOfDay,
        'endTime': endOfDay,
      });

      if (result == null) return {};

      // Convert Map<Object?, Object?> to Map<String, int>
      return result.map((key, value) => MapEntry(key.toString(), value as int));
    } on PlatformException catch (e) {
      print("Failed to get usage stats: '${e.message}'.");
      return {};
    }
  }

  @override
  Future<bool> checkUsagePermission() async {
    try {
      final bool? hasPermission = await _channel.invokeMethod<bool>('checkUsagePermission');
      return hasPermission ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  Future<void> requestUsagePermission() async {
    try {
      await _channel.invokeMethod('requestUsagePermission');
    } on PlatformException catch (e) {
      print("Failed to request permission: '${e.message}'.");
    }
  }
}
