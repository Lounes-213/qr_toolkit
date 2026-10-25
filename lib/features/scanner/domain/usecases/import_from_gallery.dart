import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:qr_toolkit/core/errors/exceptions.dart';
import 'package:qr_toolkit/core/errors/failures.dart';
import 'package:qr_toolkit/core/services/permission_service.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/features/scanner/domain/repositories/scanner_repository.dart';

class ImportFromGallery {
  ImportFromGallery(this._repository, this._permissionService);

  final ScannerRepository _repository;
  final PermissionService _permissionService;

  Future<ScanResult> call() async {
    try {
      final granted = await _permissionService.requestPhotos();
      if (!granted) throw const PermissionException();

      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (picked == null) throw const AppException('No image selected');

      final controller = MobileScannerController();
      final capture = await controller.analyzeImage(picked.path);
      await controller.dispose();

      final value = capture?.barcodes.firstOrNull?.rawValue;
      if (value == null || value.isEmpty) {
        throw const AppException('No QR code found in image');
      }

      final result = ScanResult(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        content: value,
        type: QrContentType.other,
        scannedAt: DateTime.now(),
      );
      await _repository.saveScan(result);
      return result;
    } on AppException catch (e) {
      if (e is PermissionException) throw const PermissionFailure();
      throw UnexpectedFailure(e.message);
    } on Exception catch (e) {
      throw UnexpectedFailure('Import failed: $e');
    }
  }
}
