import 'dart:io';
import 'dart:typed_data';

import 'package:qr_toolkit/shared/models/qr_model.dart';

enum ExportFormat { png, jpeg, svg, pdf }

abstract class ExportRepository {
  Future<File> saveFile(Uint8List bytes, String fileName, String mime);

  Future<void> shareFile(String path);

  String buildSvg(QrModel model);

  Future<Uint8List> buildPdf(Uint8List pngBytes);
}
