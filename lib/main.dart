import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/dependency_injection/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/controller/settings_controller.dart';
import 'features/update/presentation/update_gate.dart';
import 'features/security/presentation/security_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ProviderScope(child: QrToolkitApp()));
}

class QrToolkitApp extends ConsumerWidget {
  const QrToolkitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return UpdateGate(
      child: SecurityGate(
        child: MaterialApp.router(
          title: 'QR Toolkit',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
