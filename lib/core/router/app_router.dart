import 'package:go_router/go_router.dart';

import 'package:qr_toolkit/features/ai_generator/presentation/pages/chat_page.dart';
import 'package:qr_toolkit/features/authentication/presentation/pages/auth_page.dart';
import 'package:qr_toolkit/features/create_qr/presentation/pages/create_qr_page.dart';
import 'package:qr_toolkit/features/favorites/presentation/pages/favorites_page.dart';
import 'package:qr_toolkit/features/history/presentation/pages/history_page.dart';
import 'package:qr_toolkit/features/home/presentation/pages/home_page.dart';
import 'package:qr_toolkit/features/my_qr/presentation/pages/my_qr_page.dart';
import 'package:qr_toolkit/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:qr_toolkit/features/premium/presentation/pages/premium_page.dart';
import 'package:qr_toolkit/features/qr_designer/presentation/pages/qr_designer_page.dart';
import 'package:qr_toolkit/features/scan_result/presentation/pages/scan_result_page.dart';
import 'package:qr_toolkit/features/scanner/presentation/pages/scanner_page.dart';
import 'package:qr_toolkit/features/settings/presentation/pages/settings_page.dart';
import 'package:qr_toolkit/features/splash/presentation/pages/splash_page.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.scanner,
      builder: (_, __) => const ScannerPage(),
    ),
    GoRoute(
      path: AppRoutes.createQr,
      builder: (_, __) => const CreateQrPage(),
    ),
    GoRoute(
      path: AppRoutes.qrDesigner,
      builder: (_, __) => const QrDesignerPage(),
    ),
    GoRoute(
      path: AppRoutes.aiGenerator,
      builder: (_, __) => const ChatPage(),
    ),
    GoRoute(
      path: AppRoutes.history,
      builder: (_, __) => const HistoryPage(),
    ),
    GoRoute(
      path: AppRoutes.favorites,
      builder: (_, __) => const FavoritesPage(),
    ),
    GoRoute(
      path: AppRoutes.myQr,
      builder: (_, __) => const MyQrPage(),
    ),
    GoRoute(
      path: AppRoutes.premium,
      builder: (_, __) => const PremiumPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (_, __) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.scanResult,
      builder: (_, state) {
        final content = state.uri.queryParameters['content'] ?? '';
        final type = state.uri.queryParameters['type'] ?? 'Other';
        final scanId = state.uri.queryParameters['scanId'];
        return ScanResultPage(content: content, type: type, scanId: scanId);
      },
    ),
    GoRoute(
      path: AppRoutes.auth,
      builder: (_, __) => const AuthPage(),
    ),
  ],
);
