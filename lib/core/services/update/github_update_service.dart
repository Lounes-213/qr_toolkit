import 'package:package_info_plus/package_info_plus.dart';

import 'package:qr_toolkit/core/errors/exceptions.dart';
import 'package:qr_toolkit/core/network/api_client.dart';
import 'package:qr_toolkit/core/utils/logger.dart';
import 'update_model.dart';

/// Downloads and evaluates `version.json` from a GitHub raw URL.
/// No Firebase / Remote Config involved.
abstract class GitHubUpdateService {
  Future<UpdateCheckResult> checkForUpdate();
  Future<PackageInfo> get packageInfo;
}

class GitHubUpdateServiceImpl implements GitHubUpdateService {
  GitHubUpdateServiceImpl(this._client, this._rawUrl);

  final ApiClient _client;
  final String _rawUrl;

  @override
  Future<PackageInfo> get packageInfo => PackageInfo.fromPlatform();

  @override
  Future<UpdateCheckResult> checkForUpdate() async {
    final info = await packageInfo;
    try {
      final json = await _client.get(_rawUrl);
      final remote = VersionInfo.fromJson(json);
      final installed = info.version;
      final status = _evaluate(installed, remote);
      return UpdateCheckResult(
        status: status,
        info: remote,
        installedVersion: installed,
      );
    } on ServerException {
      return UpdateCheckResult(
        status: UpdateStatus.error,
        installedVersion: info.version,
      );
    } on Exception catch (e) {
      AppLogger.error('checkForUpdate failed', e);
      return UpdateCheckResult(
        status: UpdateStatus.error,
        installedVersion: info.version,
      );
    }
  }

  UpdateStatus _evaluate(String installed, VersionInfo remote) {
    if (_isLower(installed, remote.minimumVersion)) {
      return UpdateStatus.forceUpdate;
    }
    if (_isLower(installed, remote.latestVersion)) {
      return UpdateStatus.updateAvailable;
    }
    return UpdateStatus.upToDate;
  }

  /// Returns true if [a] is semantically lower than [b].
  bool _isLower(String a, String b) {
    final pa = a.split('+').first.split('.').map(int.tryParse).toList();
    final pb = b.split('+').first.split('.').map(int.tryParse).toList();
    final len = pb.length;
    for (var i = 0; i < len; i++) {
      final x = (i < pa.length ? pa[i] : 0) ?? 0;
      final y = (i < pb.length ? pb[i] : 0) ?? 0;
      if (x != y) return x < y;
    }
    return false;
  }
}
