import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/radius.dart';

class GradientPicker extends StatelessWidget {
  const GradientPicker({
    super.key,
    required this.onSelected,
  });

  final ValueChanged<(int, int)> onSelected;

  static const List<(int, int)> gradients = [
    (0xFF6366F1, 0xFFEC4899),
    (0xFF22D3EE, 0xFF6366F1),
    (0xFF34D399, 0xFF22D3EE),
    (0xFFFBBF24, 0xFFF87171),
    (0xFFA855F7, 0xFFEC4899),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: gradients.map((g) {
        return GestureDetector(
          onTap: () => onSelected(g),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(g.$1), Color(g.$2)],
              ),
              borderRadius: AppRadius.mdRadius,
            ),
          ),
        );
      }).toList(),
    );
  }
}
