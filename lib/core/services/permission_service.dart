import 'package:permission_handler/permission_handler.dart';
import 'package:qr_toolkit/core/errors/exceptions.dart';

abstract class PermissionService {
  Future<bool> requestCamera();
  Future<bool> requestPhotos();
  Future<PermissionStatus> cameraStatus();
}

class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      throw const PermissionException('Camera permission permanently denied');
    }
    return status.isGranted;
  }

  @override
  Future<bool> requestPhotos() async {
    final status = await Permission.photos.request();
    if (status.isPermanentlyDenied) {
      throw const PermissionException('Photos permission permanently denied');
    }
    return status.isGranted;
  }

  @override
  Future<PermissionStatus> cameraStatus() => Permission.camera.status;
}
