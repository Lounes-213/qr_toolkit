import 'package:flutter/material.dart';
import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/radius.dart';

class ScanFrame extends StatelessWidget {
  const ScanFrame({super.key, this.size = 260});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          _corner(Alignment.topLeft, true, true),
          _corner(Alignment.topRight, false, true),
          _corner(Alignment.bottomLeft, true, false),
          _corner(Alignment.bottomRight, false, false),
        ],
      ),
    );
  }

  Widget _corner(Alignment alignment, bool left, bool top) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border(
            left: left
                ? const BorderSide(color: AppColors.primaryLight, width: 4)
                : BorderSide.none,
            right: !left
                ? const BorderSide(color: AppColors.primaryLight, width: 4)
                : BorderSide.none,
            top: top
                ? const BorderSide(color: AppColors.primaryLight, width: 4)
                : BorderSide.none,
            bottom: !top
                ? const BorderSide(color: AppColors.primaryLight, width: 4)
                : BorderSide.none,
          ),
          borderRadius: AppRadius.smRadius,
        ),
      ),
    );
  }
}
