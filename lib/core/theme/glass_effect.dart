import 'package:flutter/material.dart';
import 'colors.dart';
import 'shadows.dart';

class GlassEffect {
  GlassEffect._();

  static BoxDecoration decoration({
    double opacity = 0.12,
    double blur = 16,
    double radius = 24,
    Border? border,
  }) {
    return BoxDecoration(
      color: AppColors.withOpacity(AppColors.glassSurface, opacity),
      borderRadius: BorderRadius.circular(radius),
      border: border ??
          Border.all(
            color: AppColors.withOpacity(const Color(0xFFFFFFFF), 0.18),
            width: 1,
          ),
      boxShadow: AppShadows.card,
    );
  }

  static const double defaultBlur = 16;
}
