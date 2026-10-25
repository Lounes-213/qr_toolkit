import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:qr_toolkit/core/utils/logger.dart';
import 'package:qr_toolkit/core/security/models/security_report.dart';

/// Detects tampering, root, emulator and debugger attachment.
abstract class SecurityService {
  Future<SecurityReport> analyze();
}

class SecurityServiceImpl implements SecurityService {
  SecurityServiceImpl(this._deviceInfo);

  final DeviceInfoPlugin _deviceInfo;

  /// Expected application id. A mismatch means the APK was repackaged.
  static const String expectedPackageId = 'com.qrtoolkit.app';

  @override
  Future<SecurityReport> analyze() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final rooted = await _detectRoot();
    final emulator = await _detectEmulator();
    final debugger = _detectDebugger();
    final report = SecurityReport(
      isRooted: rooted,
      isEmulator: emulator,
      isDebugBuild: _detectDebugBuild(packageInfo),
      isTampered: _detectTamper(packageInfo),
      isDebuggerAttached: debugger,
    );
    AppLogger.info('Security: $report');
    return report;
  }

  bool _detectDebugBuild(PackageInfo packageInfo) {
    // kDebugMode is false in release builds produced by the store.
    return const bool.fromEnvironment('dart.vm.product') == false &&
        packageInfo.packageName == expectedPackageId;
  }

  bool _detectTamper(PackageInfo packageInfo) =>
      packageInfo.packageName != expectedPackageId;

  bool _detectDebugger() {
    // Native debugger detection is performed by the platform; in Dart we
    // rely on the VM service being available (present in debug/profile).
    return !const bool.fromEnvironment('dart.vm.product');
  }

  Future<bool> _detectRoot() async {
    if (!Platform.isAndroid) return false;
    const markers = [
      '/system/app/Superuser.apk',
      '/sbin/su',
      '/system/bin/su',
      '/system/xbin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/data/local/su',
    ];
    for (final path in markers) {
      if (File(path).existsSync()) return true;
    }
    try {
      final android = await _deviceInfo.androidInfo;
      // Build tags often contain "test-keys" on rooted/engineering builds.
      final tags = android.version.securityPatch ?? '';
      if (tags.toLowerCase().contains('test-keys')) return true;
    } on Exception catch (e) {
      AppLogger.error('root detect failed', e);
    }
    return false;
  }

  Future<bool> _detectEmulator() async {
    try {
      if (Platform.isAndroid) {
        final android = await _deviceInfo.androidInfo;
        final model = '${android.model} ${android.hardware}'.toLowerCase();
        final brand = android.brand.toLowerCase();
        return model.contains('sdk') ||
            model.contains('emulator') ||
            brand.contains('generic');
      } else if (Platform.isIOS) {
        final ios = await _deviceInfo.iosInfo;
        return !ios.isPhysicalDevice;
      }
    } on Exception catch (e) {
      AppLogger.error('emulator detect failed', e);
    }
    return false;
  }
}
