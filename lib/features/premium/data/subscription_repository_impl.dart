import 'package:qr_toolkit/core/services/local_storage.dart';
import 'package:qr_toolkit/features/premium/data/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._storage);

  static const String _box = 'subscription_box';
  static const String _key = 'isPremium';

  final LocalStorage _storage;

  @override
  Future<bool> isPremium() async {
    return _storage.get(_box, _key, defaultValue: false) as bool;
  }

  @override
  Future<void> setPremium(bool value) async {
    await _storage.put(_box, _key, value);
  }

  @override
  Future<void> restore() async {
    // Offline-first: no remote store, so restore simply re-reads the
    // locally persisted flag.
    await isPremium();
  }
}
