import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/dependency_injection/injection.dart';
import '../../../core/services/update/github_update_service.dart';
import '../../../core/services/update/update_model.dart';

final githubUpdateServiceProvider = Provider<GitHubUpdateService>((ref) {
  return sl<GitHubUpdateService>();
});

final updateCheckProvider = FutureProvider<UpdateCheckResult>((ref) async {
  return ref.watch(githubUpdateServiceProvider).checkForUpdate();
});
