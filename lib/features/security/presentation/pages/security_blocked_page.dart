import 'package:flutter/material.dart';

import 'package:qr_toolkit/core/design_system/design_system.dart';

/// Shown when the app detects a critical security issue in release mode.
class SecurityBlockedPage extends StatelessWidget {
  const SecurityBlockedPage({super.key, required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.space5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.security, size: 56, color: AppColors.error),
              const SizedBox(height: DesignTokens.space4),
              Text(
                'Device not secure',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: DesignTokens.space2),
              Text(
                reason,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
