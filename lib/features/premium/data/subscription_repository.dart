abstract class SubscriptionRepository {
  Future<bool> isPremium();
  Future<void> setPremium(bool value);
  Future<void> restore();
}
