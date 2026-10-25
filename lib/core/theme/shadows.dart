import 'package:flutter/material.dart';
import 'colors.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.withOpacity(AppColors.primary, 0.18),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  static List<BoxShadow> get glow => [
        BoxShadow(
          color: AppColors.withOpacity(AppColors.primary, 0.45),
          blurRadius: 32,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.withOpacity(const Color(0xFF000000), 0.35),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ];
}
