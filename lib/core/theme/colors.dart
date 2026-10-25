import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand purple
  static const Color primary = Color(0xFF6C5CE7);
  static const Color primaryLight = Color(0xFF8B7CF6);
  static const Color primaryDark = Color(0xFF5A4BD1);
  static const Color secondary = Color(0xFF7C5CFC);
  static const Color accent = Color(0xFFA78BFA);

  // Gradient
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient accentGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient purpleGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Surfaces (dark theme)
  static const Color background = Color(0xFF0B0B14);
  static const Color surface = Color(0xFF15151F);
  static const Color surfaceVariant = Color(0xFF1E1E2B);
  static const Color glassSurface = Color(0x33FFFFFF);

  // Text
  static const Color textPrimary = Color(0xFFF5F5FA);
  static const Color textSecondary = Color(0xFFA0A0B2);
  static const Color textDisabled = Color(0xFF616170);

  // Status
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);
  static const Color info = Color(0xFF60A5FA);

  // Light theme surfaces
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F3F5);

  // Light text
  static const Color lightTextPrimary = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  static Color withOpacity(Color color, double opacity) =>
      color.withAlpha((opacity * 255).round());
}
