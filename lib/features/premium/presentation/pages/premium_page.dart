import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/features/premium/presentation/controller/subscription_controller.dart';

class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionControllerProvider);
    final controller = ref.read(subscriptionControllerProvider.notifier);

    ref.listen<SubscriptionState>(subscriptionControllerProvider, (prev, next) {
      if (next.isPremium && prev != null && !prev.isPremium) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Premium unlocked. Thank you!')),
        );
      }
    });

    final features = [
      'No Ads',
      'Unlimited QR Codes',
      'AI QR Generator',
      'SVG Export',
      'Cloud Sync',
      'Premium Templates',
    ];

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
          'Go Premium',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.lightTextPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.xl),

          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Center(
            child: Text(
              'Go Premium',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          Center(
            child: Text(
              'Unlock all premium features',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _PricingSelector(
            selectedPlan: _PricingPlan.yearly,
            builder: (context, selectedPlan, onSelect) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _PricingCard(
                          label: 'Monthly',
                          price: '\$2.49/month',
                          isSelected: selectedPlan == _PricingPlan.monthly,
                          onTap: () => onSelect(_PricingPlan.monthly),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _PricingCard(
                          label: 'Yearly',
                          price: '\$14.99/year',
                          badge: 'Best Value',
                          isSelected: selectedPlan == _PricingPlan.yearly,
                          onTap: () => onSelect(_PricingPlan.yearly),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _PricingCard(
                          label: 'Lifetime',
                          price: '\$29.99',
                          subtitle: 'one-time payment',
                          isSelected: selectedPlan == _PricingPlan.lifetime,
                          onTap: () => onSelect(_PricingPlan.lifetime),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.withOpacity(AppColors.success, 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.success,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      feature,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: AppSpacing.xl),

          Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: ElevatedButton(
              onPressed:
                  state.loading ? null : controller.purchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                elevation: 0,
              ),
              child: state.loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Start 7-Day Free Trial',
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Center(
            child: Text(
              'No commitment. Cancel anytime.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          Center(
            child: TextButton(
              onPressed: state.loading ? null : controller.restore,
              child: Text(
                'Restore Purchase',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

enum _PricingPlan { monthly, yearly, lifetime }

class _PricingSelector extends StatefulWidget {
  const _PricingSelector({
    required this.selectedPlan,
    required this.builder,
  });

  final _PricingPlan selectedPlan;
  final Widget Function(
    BuildContext context,
    _PricingPlan selectedPlan,
    void Function(_PricingPlan) onSelect,
  ) builder;

  @override
  State<_PricingSelector> createState() => _PricingSelectorState();
}

class _PricingSelectorState extends State<_PricingSelector> {
  late _PricingPlan _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedPlan;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selected, (plan) {
      setState(() => _selected = plan);
    });
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({
    required this.label,
    required this.price,
    this.badge,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String price;
  final String? badge;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightSurfaceVariant,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  badge!,
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              price,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.lightTextPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
