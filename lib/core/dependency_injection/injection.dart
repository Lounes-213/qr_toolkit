import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:qr_toolkit/core/services/local_storage.dart';
import 'package:qr_toolkit/core/services/permission_service.dart';
import 'package:qr_toolkit/core/network/api_client.dart';
import 'package:qr_toolkit/core/services/update/github_update_service.dart';
import 'package:qr_toolkit/core/constants/app_constants.dart';
import 'package:qr_toolkit/core/security/services/security_service.dart';
import 'package:qr_toolkit/core/security/secure_storage.dart';
import 'package:qr_toolkit/features/scanner/scanner_injection.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Core services
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<LocalStorage>(() => HiveLocalStorage());
  sl.registerLazySingleton<PermissionService>(() => PermissionServiceImpl());
  sl.registerLazySingleton<ApiClient>(
    () => HttpApiClient(
      baseUrl: 'https://api.example.com',
      client: sl(),
    ),
  );
  sl.registerLazySingleton<GitHubUpdateService>(
    () => GitHubUpdateServiceImpl(sl<ApiClient>(), AppConstants.updateRawUrl),
  );
  sl.registerLazySingleton<SecurityService>(
    () => SecurityServiceImpl(DeviceInfoPlugin()),
  );
  sl.registerLazySingleton<SecureStorage>(
    () => HiveSecureStorage(AppConstants.hiveBoxSettings),
  );
  // Initialize local storage (Hive)
  await sl<LocalStorage>().init();

  // Feature dependencies
  registerScannerDependencies(sl);
}
