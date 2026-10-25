import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/core/extensions/string_extensions.dart';
import 'package:qr_toolkit/core/utils/logger.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/features/scanner/domain/repositories/scanner_repository.dart';

class ScanQr {
  ScanQr(this._repository);

  final ScannerRepository _repository;

  Future<ScanResult> call(String rawValue) async {
    final result = ScanResult(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      content: rawValue,
      type: _classify(rawValue),
      scannedAt: DateTime.now(),
    );
    await _repository.saveScan(result);
    AppLogger.info('Scanned QR: ${result.type.name}');
    return result;
  }

  QrContentType _classify(String value) {
    if (value.isUrl) return QrContentType.url;
    if (value.isEmail) return QrContentType.email;
    if (value.startsWith('tel:') || value.isPhoneNumber) {
      return QrContentType.phone;
    }
    if (value.startsWith('WIFI:')) return QrContentType.wifi;
    if (value.startsWith('mailto:')) return QrContentType.email;
    if (value.startsWith('SMSTO:') || value.startsWith('smsto:')) {
      return QrContentType.sms;
    }
    if (value.startsWith('BEGIN:VCARD')) return QrContentType.contact;
    if (value.startsWith('geo:')) return QrContentType.geo;
    return QrContentType.text;
  }
}
