import 'package:flutter/material.dart';
import 'scan_frame.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({super.key, this.frameSize = 260});

  final double frameSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: const ColorFilter.mode(
            Color(0x800B0B14),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(child: ScanFrame(size: frameSize)),
            ],
          ),
        ),
        Center(child: ScanFrame(size: frameSize)),
      ],
    );
  }
}
