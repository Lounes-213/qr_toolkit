import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';

class BackgroundSelector extends StatelessWidget {
  const BackgroundSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final ValueChanged<int> onSelected;

  static const List<int> backgrounds = [
    0xFFFFFFFF,
    0xFF0B0B14,
    0xFF6366F1,
    0xFFEC4899,
    0xFF22D3EE,
    0xFF34D399,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: backgrounds.map((color) {
        final isSelected = color == selected;
        return GestureDetector(
          onTap: () => onSelected(color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primaryLight : Colors.transparent,
                width: 3,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
