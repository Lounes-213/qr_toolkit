import 'dart:ui';

import 'package:flutter/material.dart';

import 'colors.dart';
import 'design_tokens.dart';

/// Apple-style Liquid Glass surface with real backdrop blur, soft border
/// and layered shadows. Use it to replace flat cards for a premium feel.
class LiquidGlass extends StatelessWidget {
  const LiquidGlass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(DesignTokens.space4),
    this.radius = DesignTokens.radiusLg,
    this.blur = DesignTokens.blurLg,
    this.tint = GlassColors.mediumSurface,
    this.borderColor = GlassColors.borderLight,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final double blur;
  final Color tint;
  final Color borderColor;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ColorFilter.mode(Colors.white, BlendMode.srcOver),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: container,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: container,
      ),
    );
  }

  /// Convenience decoration for manual composition.
  static BoxDecoration decoration({
    double radius = DesignTokens.radiusLg,
    Color tint = GlassColors.mediumSurface,
    Color borderColor = GlassColors.borderLight,
    double blur = DesignTokens.blurLg,
  }) {
    return BoxDecoration(
      color: tint,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    );
  }
}
