import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;

import 'package:qr_toolkit/core/theme/colors.dart';
import 'package:qr_toolkit/core/theme/spacing.dart';
import 'package:qr_toolkit/features/export/presentation/controller/export_controller.dart';
import 'package:qr_toolkit/shared/models/qr_model.dart';
import 'package:qr_toolkit/shared/widgets/gradient_button.dart';

typedef CaptureFn = Future<Uint8List> Function({bool highRes});

class ExportMenu extends ConsumerWidget {
  const ExportMenu({
    super.key,
    required this.model,
    required this.capture,
  });

  final QrModel model;
  final CaptureFn capture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExporting = ref.watch(
      exportControllerProvider.select((s) => s.isExporting),
    );
    final controller = ref.read(exportControllerProvider.notifier);

    Future<Uint8List> toJpeg(Uint8List png) async {
      final decoded = img.decodeImage(png);
      if (decoded == null) throw StateError('Failed to decode PNG');
      return img.encodeJpg(decoded, quality: 90);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GradientButton(
          label: isExporting ? 'Exporting…' : 'Export PNG',
          icon: Icons.download,
          onPressed: isExporting
              ? () {}
              : () {
                  capture().then(controller.savePng);
                },
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isExporting
                    ? null
                    : () {
                        capture().then(controller.sharePng);
                      },
                icon: const Icon(Icons.share, color: AppColors.textPrimary),
                label: const Text('Share',
                    style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isExporting
                    ? null
                    : () {
                        capture().then(controller.savePng);
                      },
                icon: const Icon(Icons.save, color: AppColors.textPrimary),
                label: const Text('Save',
                    style: TextStyle(color: AppColors.textPrimary)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _chip(
              'High-Res PNG',
              isExporting,
              () {
                capture(highRes: true).then(controller.savePng);
              },
            ),
            _chip(
              'JPEG',
              isExporting,
              () {
                () async {
                  final jpg = await toJpeg(await capture());
                  await controller.saveJpeg(jpg);
                }();
              },
            ),
            _chip(
              'SVG',
              isExporting,
              () {
                controller.buildAndShareSvg(model);
              },
            ),
            _chip(
              'PDF',
              isExporting,
              () {
                capture().then(controller.buildAndSharePdf);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _chip(String label, bool disabled, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: disabled ? null : onTap,
      child: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
    );
  }
}

extension ExportMenuCapture on GlobalKey {
  Future<Uint8List> capture({bool highRes = false}) async {
    final boundary =
        currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) throw StateError('RepaintBoundary not found');
    final pixelRatio = highRes ? 5.0 : 1.0;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
