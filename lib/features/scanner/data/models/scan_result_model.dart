import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';

part 'scan_result_model.freezed.dart';
part 'scan_result_model.g.dart';

@freezed
class ScanResultModel with _$ScanResultModel {
  const ScanResultModel._();

  const factory ScanResultModel({
    required String id,
    required String content,
    required String type,
    required int scannedAtMillis,
    String? title,
  }) = _ScanResultModel;

  factory ScanResultModel.fromJson(Map<String, dynamic> json) =>
      _$ScanResultModelFromJson(json);

  factory ScanResultModel.fromEntity(ScanResult entity) {
    return ScanResultModel(
      id: entity.id,
      content: entity.content,
      type: entity.type.name,
      scannedAtMillis: entity.scannedAt.millisecondsSinceEpoch,
      title: entity.title,
    );
  }

  ScanResult toEntity() {
    return ScanResult(
      id: id,
      content: content,
      type: QrContentType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => QrContentType.other,
      ),
      scannedAt: DateTime.fromMillisecondsSinceEpoch(scannedAtMillis),
      title: title,
    );
  }
}
