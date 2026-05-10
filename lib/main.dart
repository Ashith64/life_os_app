import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/background/work_manager_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Background tasks (WorkManager)
  await WorkManagerService.initialize();
  await WorkManagerService.registerScreenTimeSync();

  runApp(
    const ProviderScope(
      child: LifeOSApp(),
    ),
  );
}

class LifeOSApp extends ConsumerWidget {
  const LifeOSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'LifeOS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Enforce dark mode first
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
