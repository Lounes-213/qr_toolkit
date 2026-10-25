import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/features/history/presentation/controller/history_controller.dart';
import 'package:qr_toolkit/features/history/presentation/widgets/history_list_item.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';
import 'package:qr_toolkit/shared/widgets/empty_state.dart';
import 'package:qr_toolkit/shared/widgets/loading_view.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(historyControllerProvider.notifier).load(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _dateGroupKey(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scanned = DateTime(date.year, date.month, date.day);
    final diff = today.difference(scanned).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }

  Map<String, List<ScanResult>> _groupByDate(List<ScanResult> items) {
    final map = <String, List<ScanResult>>{};
    for (final scan in items) {
      final key = _dateGroupKey(scan.scannedAt);
      map.putIfAbsent(key, () => []).add(scan);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'History',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: controller.onSearch,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.lightTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search history...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.lightTextSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 2,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: QrContentType.values.length + 1,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index == 0) {
                  final selected = state.filter == null;
                  return FilterChip(
                    label: const Text('All'),
                    selected: selected,
                    onSelected: (_) => controller.setFilter(null),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.lightSurfaceVariant,
                    labelStyle: TextStyle(
                      color: selected
                          ? Colors.white
                          : AppColors.lightTextSecondary,
                    ),
                    checkmarkColor: Colors.white,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  );
                }
                final type = QrContentType.values[index - 1];
                final selected = state.filter == type;
                return FilterChip(
                  label: Text(type.label),
                  selected: selected,
                  onSelected: (_) => controller.setFilter(type),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.lightSurfaceVariant,
                  labelStyle: TextStyle(
                    color: selected
                        ? Colors.white
                        : AppColors.lightTextSecondary,
                  ),
                  checkmarkColor: Colors.white,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.isLoading) {
                  return const LoadingView();
                }
                final results = state.filteredScans;
                if (results.isEmpty) {
                  return const EmptyState(
                    message: 'No scans match your filters',
                    icon: Icons.history,
                  );
                }

                final grouped = _groupByDate(results);
                final headers = ['Today', 'Yesterday', '2 days ago'];
                final otherKeys = grouped.keys
                    .where((k) => !headers.contains(k))
                    .toList();

                final allKeys = <String>[
                  ...headers.where(grouped.containsKey),
                  ...otherKeys,
                ];

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: allKeys.length,
                  itemBuilder: (context, index) {
                    final groupKey = allKeys[index];
                    final items = grouped[groupKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: index == 0 ? AppSpacing.sm : AppSpacing.lg,
                            bottom: AppSpacing.sm,
                            left: AppSpacing.xs,
                          ),
                          child: Text(
                            groupKey.toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.lightTextSecondary,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ...items.map((scan) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: HistoryListItem(
                                scan: scan,
                                confirmDismiss: () async {
                                  return true;
                                },
                                onDismiss: () => controller.delete(scan.id),
                              ),
                            )),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
