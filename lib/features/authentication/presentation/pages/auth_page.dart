import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/shared/widgets/gradient_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppRadius.lgRadius,
              ),
              child: const Icon(Icons.lock_outline, size: 48, color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Sign in to sync',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GradientButton(
              label: 'Continue with Google',
              icon: Icons.g_mobiledata,
              onPressed: () => context.pop(),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Maybe later',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
