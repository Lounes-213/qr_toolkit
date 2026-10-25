import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr/qr.dart';
import 'package:share_plus/share_plus.dart';

import 'package:qr_toolkit/features/export/domain/export_repository.dart';
import 'package:qr_toolkit/shared/models/qr_model.dart';

class ExportRepositoryImpl implements ExportRepository {
  @override
  Future<File> saveFile(Uint8List bytes, String fileName, String mime) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  @override
  Future<void> shareFile(String path) async {
    await Share.shareXFiles([XFile(path)]);
  }

  @override
  String buildSvg(QrModel model) {
    final data = model.content.isEmpty ? 'https://qr-toolkit.app' : model.content;
    final qr = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final image = QrImage(qr);
    final count = image.moduleCount;
    final quiet = 4;
    final total = count + quiet * 2;

    final fg = '#${model.color.toRadixString(16).padLeft(8, '0').substring(2)}';
    final bg = '#${model.backgroundColor.toRadixString(16).padLeft(8, '0').substring(2)}';

    final buffer = StringBuffer();
    buffer.write(
      '<svg xmlns="http://www.w3.org/2000/svg" width="$total" height="$total" '
      'viewBox="0 0 $total $total">',
    );
    buffer.write('<rect width="$total" height="$total" fill="$bg"/>');
    for (var row = 0; row < count; row++) {
      for (var col = 0; col < count; col++) {
        if (image.isDark(row, col)) {
          final x = col + quiet;
          final y = row + quiet;
          buffer.write('<rect x="$x" y="$y" width="1" height="1" fill="$fg"/>');
        }
      }
    }
    buffer.write('</svg>');
    return buffer.toString();
  }

  @override
  Future<Uint8List> buildPdf(Uint8List pngBytes) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Image(
            pw.MemoryImage(pngBytes),
            fit: pw.BoxFit.contain,
          ),
        ),
      ),
    );
    return doc.save();
  }
}
