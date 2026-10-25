import 'package:hive_flutter/hive_flutter.dart';

import 'package:qr_toolkit/core/errors/exceptions.dart';
import 'package:qr_toolkit/features/scanner/data/models/scan_result_model.dart';

abstract class ScannerLocalDataSource {
  Future<List<ScanResultModel>> getScans();
  Future<void> saveScan(ScanResultModel model);
  Future<void> deleteScan(String id);
  Future<void> clear();
}

class ScannerLocalDataSourceImpl implements ScannerLocalDataSource {
  ScannerLocalDataSourceImpl(this.boxName);

  final String boxName;

  Future<Box> get _box async => Hive.openBox(boxName);

  @override
  Future<List<ScanResultModel>> getScans() async {
    try {
      final box = await _box;
      return box.values
          .map((e) => ScanResultModel.fromJson(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.scannedAtMillis.compareTo(a.scannedAtMillis));
    } on Exception catch (e) {
      throw CacheException('Failed to read scans: $e');
    }
  }

  @override
  Future<void> saveScan(ScanResultModel model) async {
    final box = await _box;
    await box.put(model.id, model.toJson());
  }

  @override
  Future<void> deleteScan(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
