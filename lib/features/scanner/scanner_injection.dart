import 'package:get_it/get_it.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/permission_service.dart';
import 'data/datasource/scanner_local_datasource.dart';
import 'data/repositories/scanner_repository_impl.dart';
import 'domain/repositories/scanner_repository.dart';
import 'domain/usecases/import_from_gallery.dart';
import 'domain/usecases/scan_barcode.dart';
import 'domain/usecases/scan_qr.dart';

void registerScannerDependencies(GetIt sl) {
  sl.registerLazySingleton<ScannerLocalDataSource>(
    () => ScannerLocalDataSourceImpl(AppConstants.hiveBoxScans),
  );
  sl.registerLazySingleton<ScannerRepository>(
    () => ScannerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ScanQr(sl()));
  sl.registerLazySingleton(() => ScanBarcode(sl()));
  sl.registerLazySingleton(
    () => ImportFromGallery(sl(), sl<PermissionService>()),
  );
}
