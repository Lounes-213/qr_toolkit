import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';

class LogoPicker extends StatelessWidget {
  const LogoPicker({
    super.key,
    required this.logoPath,
    required this.onPick,
  });

  final String? logoPath;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(
            color: AppColors.withOpacity(const Color(0xFFFFFFFF), 0.12),
          ),
        ),
        child: logoPath != null
            ? ClipRRect(
                borderRadius: AppRadius.mdRadius,
                child: Image.asset(logoPath!, fit: BoxFit.cover),
              )
            : const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_photo_alternate, color: AppColors.textSecondary),
                    SizedBox(height: 8),
                    Text(
                      'Add logo',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
