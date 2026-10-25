import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/shared/widgets/gradient_button.dart';

class ExportButtons extends StatelessWidget {
  const ExportButtons({
    super.key,
    required this.onExportPng,
    required this.onShare,
    required this.onSave,
  });

  final VoidCallback onExportPng;
  final VoidCallback onShare;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientButton(
          label: 'Export PNG',
          icon: Icons.download,
          onPressed: onExportPng,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share, color: AppColors.textPrimary),
                label: const Text('Share',
                    style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.save, color: AppColors.textPrimary),
                label: const Text('Save',
                    style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
