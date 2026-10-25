import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dependency_injection/injection.dart';
import '../../../core/security/services/security_service.dart';
import '../../../core/security/models/security_report.dart';

final securityServiceProvider = Provider<SecurityService>((ref) {
  return sl<SecurityService>();
});

final securityReportProvider = FutureProvider<SecurityReport>((ref) async {
  return ref.watch(securityServiceProvider).analyze();
});
