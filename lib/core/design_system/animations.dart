import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppAnimations {
  AppAnimations._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration page = Duration(milliseconds: 450);

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve emphasized = Curves.easeOutExpo;
  static const Curve decelerate = Curves.decelerate;

  /// Page transition builder for GoRouter.
  static CustomTransitionPage<T> slideFade<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: standard));
        final fade = CurvedAnimation(parent: animation, curve: standard);
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(position: offset, child: child),
        );
      },
      transitionDuration: page,
    );
  }
}
