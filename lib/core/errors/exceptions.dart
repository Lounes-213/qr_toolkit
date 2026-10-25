class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server exception']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache exception']);
}

class PermissionException extends AppException {
  const PermissionException([super.message = 'Permission denied']);
}
