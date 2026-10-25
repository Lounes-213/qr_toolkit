import 'dart:convert';

import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';

class ExportJson {
  const ExportJson();

  String call(List<ScanResult> scans) {
    final list = scans.map((s) => s.toJson()).toList();
    return jsonEncode(list);
  }
}
