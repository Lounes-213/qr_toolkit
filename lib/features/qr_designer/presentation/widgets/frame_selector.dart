import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';

class FrameSelector extends StatelessWidget {
  const FrameSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  static const List<String> frames = ['none', 'soft', 'sharp', 'banner'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: frames.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final frame = frames[index];
          final isSelected = frame == selected;
          return GestureDetector(
            onTap: () => onSelected(frame),
            child: Container(
              width: 72,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: AppRadius.mdRadius,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.withOpacity(const Color(0xFFFFFFFF), 0.1),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                frame.capitalize,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension _Capitalize on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
