import 'package:flutter/material.dart';

import 'colors.dart';

class AppGradients {
  AppGradients._();

  static const Gradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accent = LinearGradient(
    colors: [AppColors.accent, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient sunset = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEC4899)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient ocean = LinearGradient(
    colors: [Color(0xFF22D3EE), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient aurora = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFF22D3EE), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient mesh = RadialGradient(
    colors: [AppColors.primary, AppColors.secondary, AppColors.accent],
    stops: [0.0, 0.5, 1.0],
    center: Alignment.topRight,
    radius: 1.2,
  );

  static List<Gradient> get all => [primary, accent, sunset, ocean, aurora];
}
