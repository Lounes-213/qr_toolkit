import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/features/history/presentation/controller/history_controller.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/shared/widgets/glass_card.dart';

class HistoryListItem extends ConsumerWidget {
  const HistoryListItem({
    super.key,
    required this.scan,
    this.onDismiss,
    this.confirmDismiss,
  });

  final ScanResult scan;
  final VoidCallback? onDismiss;
  final Future<bool?> Function()? confirmDismiss;

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(scan.type.icon, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(scan.type.label, style: AppTypography.titleMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SelectableText(
              scan.content,
              style: AppTypography.bodyLarge
                  .copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                Share.share(scan.content);
              },
              icon: const Icon(Icons.share),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref
        .watch(historyControllerProvider)
        .favoriteIds
        .contains(scan.id);

    final card = GlassCard(
      onTap: () => _showDetails(context),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.withOpacity(AppColors.primary, 0.15),
            child: Icon(scan.type.icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scan.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  scan.title ?? scan.type.label,
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatDate(scan.scannedAt),
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.textDisabled),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? AppColors.warning : AppColors.textSecondary,
            ),
            onPressed: () =>
                ref.read(historyControllerProvider.notifier).toggleFavorite(scan.id),
          ),
        ],
      ),
    );

    if (onDismiss == null) return card;

    return Dismissible(
      key: Key(scan.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => confirmDismiss?.call() ?? Future.value(true),
      onDismissed: (_) => onDismiss!.call(),
      child: card,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final sameDay = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
    final time =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    if (sameDay) return 'Today $time';
    return '${date.day}/${date.month}/${date.year} $time';
  }
}
