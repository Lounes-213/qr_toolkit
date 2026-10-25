import 'package:equatable/equatable.dart';

/// Mirrors the `version.json` hosted on GitHub raw.
class VersionInfo extends Equatable {
  const VersionInfo({
    required this.latestVersion,
    required this.minimumVersion,
    required this.forceUpdate,
    required this.url,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      latestVersion: json['latest_version'] as String? ?? '0.0.0',
      minimumVersion: json['minimum_version'] as String? ?? '0.0.0',
      forceUpdate: json['force_update'] as bool? ?? false,
      url: json['url'] as String? ?? '',
    );
  }

  final String latestVersion;
  final String minimumVersion;
  final bool forceUpdate;
  final String url;

  @override
  List<Object> get props => [latestVersion, minimumVersion, forceUpdate, url];
}

enum UpdateStatus { upToDate, updateAvailable, forceUpdate, error }

class UpdateCheckResult extends Equatable {
  const UpdateCheckResult({
    required this.status,
    this.info,
    this.installedVersion = '',
  });

  final UpdateStatus status;
  final VersionInfo? info;
  final String installedVersion;

  bool get mustForce => status == UpdateStatus.forceUpdate;
  bool get canUpdate => status == UpdateStatus.updateAvailable;

  @override
  List<Object?> get props => [status, info, installedVersion];
}
