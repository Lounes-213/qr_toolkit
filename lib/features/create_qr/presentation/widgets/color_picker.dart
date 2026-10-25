import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final ValueChanged<int> onSelected;

  static const List<int> palette = [
    0xFF000000,
    0xFF6366F1,
    0xFFEC4899,
    0xFF22D3EE,
    0xFF34D399,
    0xFFFBBF24,
    0xFFF87171,
    0xFFFFFFFF,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: palette.map((color) {
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
              boxShadow: isSelected
                  ? const [BoxShadow(color: Color(0x336366F1), blurRadius: 12)]
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
