import 'package:flutter/widgets.dart';

import 'package:qr_toolkit/core/services/ads/ads_config.dart';
import 'package:qr_toolkit/core/services/ads/ads_service.dart';
import 'package:qr_toolkit/core/utils/logger.dart';

/// Factory that returns a concrete [AdsService] for the given [AdsConfig].
///
/// Each concrete class is a stub that implements the [AdsService] interface and
/// logs its intent. The real ad SDK would be wired inside the corresponding
/// implementation once the dependency is added to `pubspec.yaml`.
AdsService createAdsService(AdsConfig config) {
  switch (config.provider) {
    case AdProvider.admob:
      return AdMobAdsService(config);
    case AdProvider.applovin:
      return AppLovinAdsService(config);
    case AdProvider.unity:
      return UnityAdsService(config);
    case AdProvider.pangle:
      return PangleAdsService(config);
  }
}

/// Stub implementation for Google AdMob.
class AdMobAdsService implements AdsService {
  const AdMobAdsService(this.config);

  final AdsConfig config;

  @override
  Future<void> init() async {
    AppLogger.info('[AdMob] init() — wire google_mobile_ads here.');
  }

  @override
  Future<void> showInterstitial() async {
    AppLogger.info('[AdMob] showInterstitial() — stub, no real ad.');
  }

  @override
  Future<void> showRewarded(Function onRewarded) async {
    AppLogger.info('[AdMob] showRewarded() — granting reward (stub).');
    onRewarded();
  }

  @override
  Widget buildBanner() {
    AppLogger.debug('[AdMob] buildBanner() — returning empty stub.');
    return const SizedBox.shrink();
  }

  @override
  String get providerName => 'AdMob';
}

/// Stub implementation for AppLovin.
class AppLovinAdsService implements AdsService {
  const AppLovinAdsService(this.config);

  final AdsConfig config;

  @override
  Future<void> init() async {
    AppLogger.info('[AppLovin] init() — wire applovin SDK here.');
  }

  @override
  Future<void> showInterstitial() async {
    AppLogger.info('[AppLovin] showInterstitial() — stub, no real ad.');
  }

  @override
  Future<void> showRewarded(Function onRewarded) async {
    AppLogger.info('[AppLovin] showRewarded() — granting reward (stub).');
    onRewarded();
  }

  @override
  Widget buildBanner() {
    AppLogger.debug('[AppLovin] buildBanner() — returning empty stub.');
    return const SizedBox.shrink();
  }

  @override
  String get providerName => 'AppLovin';
}

/// Stub implementation for Unity Ads.
class UnityAdsService implements AdsService {
  const UnityAdsService(this.config);

  final AdsConfig config;

  @override
  Future<void> init() async {
    AppLogger.info('[Unity] init() — wire unity_ads here.');
  }

  @override
  Future<void> showInterstitial() async {
    AppLogger.info('[Unity] showInterstitial() — stub, no real ad.');
  }

  @override
  Future<void> showRewarded(Function onRewarded) async {
    AppLogger.info('[Unity] showRewarded() — granting reward (stub).');
    onRewarded();
  }

  @override
  Widget buildBanner() {
    AppLogger.debug('[Unity] buildBanner() — returning empty stub.');
    return const SizedBox.shrink();
  }

  @override
  String get providerName => 'Unity';
}

/// Stub implementation for Pangle (ByteDance).
class PangleAdsService implements AdsService {
  const PangleAdsService(this.config);

  final AdsConfig config;

  @override
  Future<void> init() async {
    AppLogger.info('[Pangle] init() — wire pangle SDK here.');
  }

  @override
  Future<void> showInterstitial() async {
    AppLogger.info('[Pangle] showInterstitial() — stub, no real ad.');
  }

  @override
  Future<void> showRewarded(Function onRewarded) async {
    AppLogger.info('[Pangle] showRewarded() — granting reward (stub).');
    onRewarded();
  }

  @override
  Widget buildBanner() {
    AppLogger.debug('[Pangle] buildBanner() — returning empty stub.');
    return const SizedBox.shrink();
  }

  @override
  String get providerName => 'Pangle';
}
