import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';

class EyeStyleSelector extends StatelessWidget {
  const EyeStyleSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  static const List<String> styles = ['square', 'circle', 'rounded'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: styles.map((style) {
        final isSelected = style == selected;
        return ChoiceChip(
          label: Text(style.capitalize),
          selected: isSelected,
          onSelected: (_) => onSelected(style),
          selectedColor: AppColors.primary,
          backgroundColor: AppColors.surfaceVariant,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        );
      }).toList(),
    );
  }
}

extension _Capitalize on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
