class AppConstants {
  AppConstants._();

  static const String appName = 'QR Toolkit';
  static const String appVersion = '1.0.0';

  static const String hiveBoxScans = 'scans_box';
  static const String hiveBoxSettings = 'settings_box';

  static const int maxRecentScans = 50;
  static const Duration scanThrottle = Duration(milliseconds: 500);

  /// Raw GitHub URL that hosts `version.json`.
  static const String updateRawUrl =
      'https://raw.githubusercontent.com/your-org/qr_toolkit/main/version.json';

  /// Store URL used by the "Rate App" action.
  static const String rateAppUrl =
      'https://play.google.com/store/apps/details?id=qr_toolkit';

  /// Email address used by the "Feedback" action.
  static const String feedbackEmail = 'support@qrtoolkit.app';

  static const String privacyUrl = 'https://qrtoolkit.app/privacy';
}
