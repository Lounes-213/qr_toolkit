import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/shared/widgets/gradient_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: AppRadius.lgRadius,
              ),
              child: const Icon(Icons.auto_awesome, size: 56, color: Colors.white),
            ).animate().fadeIn().scale(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Create & Scan with Style',
              style: AppTypography.displayMedium
                  .copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Generate beautiful QR codes, scan anything, and design like a pro.',
              style: AppTypography.bodyLarge
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            GradientButton(
              label: 'Get Started',
              onPressed: () => context.go('/home'),
              icon: Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}
