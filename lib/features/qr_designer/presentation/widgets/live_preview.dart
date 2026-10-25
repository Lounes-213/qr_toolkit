import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:qr_toolkit/shared/models/qr_model.dart';

class LivePreview extends StatelessWidget {
  const LivePreview({super.key, required this.model});

  final QrModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(model.backgroundColor),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: QrImageView(
        data: model.content.isEmpty ? 'https://qr-toolkit.app' : model.content,
        version: QrVersions.auto,
        size: 220,
        backgroundColor: Colors.transparent,
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(model.color),
        ),
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(model.color),
        ),
      ),
    );
  }
}
