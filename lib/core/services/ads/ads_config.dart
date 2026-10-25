/// Supported ads provider SDKs.
enum AdProvider { admob, applovin, unity, pangle }

/// Configuration describing which provider to use and its unit ids.
class AdsConfig {
  const AdsConfig({
    required this.provider,
    this.unitIds = const <String, String>{},
  });

  final AdProvider provider;
  final Map<String, String> unitIds;

  /// Default configuration used by the app (AdMob stub).
  static const AdsConfig defaults = AdsConfig(
    provider: AdProvider.admob,
    unitIds: <String, String>{
      'banner': 'ca-app-pub-0000000000000000/0000000000',
      'interstitial': 'ca-app-pub-0000000000000000/0000000000',
      'rewarded': 'ca-app-pub-0000000000000000/0000000000',
    },
  );
}
