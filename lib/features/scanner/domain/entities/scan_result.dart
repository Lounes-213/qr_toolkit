import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:qr_toolkit/shared/enums/qr_content_type.dart';

part 'scan_result.freezed.dart';
part 'scan_result.g.dart';

@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({
    required String id,
    required String content,
    required QrContentType type,
    required DateTime scannedAt,
    String? title,
  }) = _ScanResult;

  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);
}
