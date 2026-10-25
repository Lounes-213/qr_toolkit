import 'package:flutter/material.dart';

class DesignTokens {
  DesignTokens._();

  // Spacing scale (4pt base)
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 24;
  static const double space6 = 32;
  static const double space7 = 48;
  static const double space8 = 64;

  // Radius (Material 3 + Apple)
  static const double radiusXs = 8;
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;
  static const double radiusPill = 999;

  // Elevation / blur
  static const double blurSm = 8;
  static const double blurMd = 16;
  static const double blurLg = 28;
  static const double blurXl = 40;

  // Standard insets
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(
    space4,
    space5,
    space4,
    space5,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(space4);

  // Icon sizes
  static const double iconSm = 18;
  static const double iconMd = 24;
  static const double iconLg = 32;
}
