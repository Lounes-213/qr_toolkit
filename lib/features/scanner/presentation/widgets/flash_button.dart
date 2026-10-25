import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';

class FlashButton extends StatelessWidget {
  const FlashButton({
    super.key,
    required this.isOn,
    required this.onToggle,
  });

  final bool isOn;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.withOpacity(AppColors.glassSurface, 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.withOpacity(const Color(0xFFFFFFFF), 0.18),
          ),
        ),
        child: Icon(
          isOn ? Icons.flash_on : Icons.flash_off,
          color: isOn ? AppColors.warning : AppColors.textSecondary,
        ),
      ),
    );
  }
}
