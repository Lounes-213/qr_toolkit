import 'package:flutter/animation.dart';

class AppAnimations {
  AppAnimations._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 600);

  static const Curve standard = Curves.easeInOutCubic;
  static const Curve emphasized = Curves.easeOutExpo;
  static const Curve decelerate = Curves.decelerate;
}
