import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/features/scanner/domain/repositories/scanner_repository.dart';

class ScanBarcode {
  ScanBarcode(this._repository);

  final ScannerRepository _repository;

  Future<ScanResult> call(String rawValue, String format) async {
    final result = ScanResult(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: rawValue,
      type: QrContentType.other,
      scannedAt: DateTime.now(),
    );
    await _repository.saveScan(result);
    return result;
  }
}
