import 'package:flutter/widgets.dart';

/// Abstract contract for any ads provider implementation.
///
/// Business logic must depend only on this interface so that swapping the
/// underlying provider (AdMob, AppLovin, Unity, Pangle) requires no changes in
/// the calling code. Concrete implementations live in `ads_factory.dart`.
abstract class AdsService {
  /// Initializes the underlying ad SDK with the configured unit ids.
  Future<void> init();

  /// Shows an interstitial ad (or a no-op stub when not wired).
  Future<void> showInterstitial();

  /// Shows a rewarded ad and invokes [onRewarded] once the reward is granted.
  Future<void> showRewarded(Function onRewarded);

  /// Builds a banner ad widget. Returns an empty [SizedBox] in stub mode.
  Widget buildBanner();

  /// Human-readable name of the active provider.
  String get providerName;
}
