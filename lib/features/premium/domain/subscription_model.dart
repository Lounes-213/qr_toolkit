import 'package:equatable/equatable.dart';

enum SubscriptionTier { free, premium }

class SubscriptionModel extends Equatable {
  const SubscriptionModel({
    this.isPremium = false,
    this.tier = SubscriptionTier.free,
    this.expiry,
  });

  final bool isPremium;
  final SubscriptionTier tier;
  final DateTime? expiry;

  SubscriptionModel copyWith({
    bool? isPremium,
    SubscriptionTier? tier,
    DateTime? expiry,
  }) {
    return SubscriptionModel(
      isPremium: isPremium ?? this.isPremium,
      tier: tier ?? this.tier,
      expiry: expiry ?? this.expiry,
    );
  }

  @override
  List<Object?> get props => [isPremium, tier, expiry];
}
