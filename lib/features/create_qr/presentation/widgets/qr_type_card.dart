import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/core/theme/typography.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';

class QrTypeCard extends StatelessWidget {
  const QrTypeCard({
    super.key,
    required this.type,
    required this.onTap,
  });

  final QrContentType type;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: AppRadius.mdRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(type.icon, color: AppColors.primaryLight, size: 28),
              const SizedBox(height: 8),
              Text(
                type.label,
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
