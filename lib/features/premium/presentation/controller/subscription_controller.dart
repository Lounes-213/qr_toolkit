import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/dependency_injection/injection.dart';
import 'package:qr_toolkit/core/services/local_storage.dart';
import 'package:qr_toolkit/features/premium/data/subscription_repository.dart';
import 'package:qr_toolkit/features/premium/data/subscription_repository_impl.dart';

final subscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, SubscriptionState>(
  (ref) => SubscriptionController(
    SubscriptionRepositoryImpl(sl<LocalStorage>()),
  ),
);

class SubscriptionState {
  const SubscriptionState({
    this.isPremium = false,
    this.loading = false,
  });

  final bool isPremium;
  final bool loading;

  SubscriptionState copyWith({bool? isPremium, bool? loading}) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      loading: loading ?? this.loading,
    );
  }
}

class SubscriptionController extends StateNotifier<SubscriptionState> {
  SubscriptionController(this._repository)
      : super(const SubscriptionState());

  final SubscriptionRepository _repository;

  Future<void> load() async {
    final premium = await _repository.isPremium();
    state = state.copyWith(isPremium: premium, loading: false);
  }

  Future<void> purchase() async {
    state = state.copyWith(loading: true);
    // Offline-first: simulate a successful purchase.
    await _repository.setPremium(true);
    final premium = await _repository.isPremium();
    state = state.copyWith(isPremium: premium, loading: false);
  }

  Future<void> restore() async {
    state = state.copyWith(loading: true);
    await _repository.restore();
    final premium = await _repository.isPremium();
    state = state.copyWith(isPremium: premium, loading: false);
  }
}
