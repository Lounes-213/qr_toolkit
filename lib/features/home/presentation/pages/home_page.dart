import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  static const _quickActions = [
    _QuickActionData('Scan QR', Icons.qr_code_scanner, '/scanner'),
    _QuickActionData('Create QR', Icons.add_circle_outline, '/create'),
    _QuickActionData('My QR', Icons.qr_code, '/my-qr'),
    _QuickActionData('History', Icons.history, '/history'),
    _QuickActionData('Favorites', Icons.star, '/favorites'),
    _QuickActionData('AI Generator', Icons.auto_awesome, '/ai'),
    _QuickActionData('WiFi QR', Icons.wifi, '/create'),
    _QuickActionData('Contact QR', Icons.contacts, '/create'),
    _QuickActionData('URL QR', Icons.link, '/create'),
    _QuickActionData('Payment QR', Icons.payment, '/create'),
    _QuickActionData('PDF QR', Icons.picture_as_pdf, '/create'),
    _QuickActionData('Social QR', Icons.share, '/create'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: AppSpacing.md),
                _buildSearchBar(),
                const SizedBox(height: AppSpacing.lg),
                _buildFeatureCards(),
                const SizedBox(height: AppSpacing.lg),
                _buildQuickActions(),
                const SizedBox(height: AppSpacing.lg),
                _buildRecentSection(),
                const SizedBox(height: AppSpacing.lg),
                _buildPremiumBanner(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildCreateFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'LouneS \u{1F44B}',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.lightSurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: AppColors.lightTextSecondary,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.lightSurfaceVariant,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search, color: AppColors.lightTextSecondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search anything...',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Row(
      children: [
        Expanded(
          child: _buildGradientCard(
            title: 'Quick Scan',
            subtitle: 'Scan any QR or barcode',
            actionLabel: 'Scan Now',
            icon: Icons.camera_alt_outlined,
            onTap: () => context.push('/scanner'),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _buildGradientCard(
            title: 'AI QR Generator',
            subtitle: 'Generate Smart QR Codes',
            actionLabel: 'Try Now',
            icon: Icons.smart_toy_outlined,
            onTap: () => context.push('/ai'),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientCard({
    required String title,
    required String subtitle,
    required String actionLabel,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              actionLabel,
              style: AppTypography.labelMedium.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _quickActions.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.sm,
          ),
          itemBuilder: (context, index) {
            final action = _quickActions[index];
            return _buildQuickActionItem(
              icon: action.icon,
              label: action.label,
              onTap: () => context.push(action.route),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.lightSurface,
              borderRadius: AppRadius.smRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent QR Codes',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.lightTextPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/my-qr'),
              child: Text(
                'See all',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              return Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: AppRadius.mdRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.qr_code_2,
                    color: AppColors.lightTextSecondary,
                    size: 48,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBanner() {
    return GestureDetector(
      onTap: () => context.push('/premium'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Premium',
                    style: AppTypography.titleMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Unlock all features, no ads, more power',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(999),
                      ),
                    ),
                    child: Text(
                      'Go Premium',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.workspace_premium,
              color: Colors.white.withValues(alpha: 0.3),
              size: 64,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return SizedBox(
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: AppColors.lightSurface,
              border: Border(
                top: BorderSide(
                  color: AppColors.lightSurfaceVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  index: 0,
                ),
                const SizedBox(width: 64),
                _buildNavItem(
                  icon: Icons.history,
                  label: 'History',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.person,
                  label: 'Profile',
                  index: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _currentNavIndex = index);
        if (label == 'History') context.push('/history');
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.lightTextSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateFab() {
    return GestureDetector(
      onTap: () => context.push('/create'),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

class _QuickActionData {
  final String label;
  final IconData icon;
  final String route;

  const _QuickActionData(this.label, this.icon, this.route);
}
