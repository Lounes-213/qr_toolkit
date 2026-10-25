import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/features/history/presentation/controller/history_controller.dart';
import 'package:qr_toolkit/features/history/presentation/widgets/history_list_item.dart';
import 'package:qr_toolkit/shared/widgets/empty_state.dart';
import 'package:qr_toolkit/shared/widgets/loading_view.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(historyControllerProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const LoadingView();
          }
          final favorites = state.favoriteScans;
          if (favorites.isEmpty) {
            return const EmptyState(
              message: 'No favorites yet',
              icon: Icons.star_outline,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: favorites.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final scan = favorites[index];
              return HistoryListItem(
                scan: scan,
                confirmDismiss: () async {
                  return true;
                },
                onDismiss: () => controller.toggleFavorite(scan.id),
              );
            },
          );
        },
      ),
    );
  }
}
