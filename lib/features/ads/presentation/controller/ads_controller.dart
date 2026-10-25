import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/services/ads/ads_config.dart';
import 'package:qr_toolkit/core/services/ads/ads_factory.dart';
import 'package:qr_toolkit/core/services/ads/ads_service.dart';

/// Provides an [AdsService] built from the default [AdsConfig].
///
/// Business logic should depend solely on this provider. To switch providers,
/// change only the [AdsConfig] passed to [createAdsService] — no business-logic
/// edits required.
final adsControllerProvider = Provider<AdsService>((ref) {
  return createAdsService(AdsConfig.defaults);
});
