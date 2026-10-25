import 'package:qr_toolkit/core/errors/failures.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/features/scanner/domain/repositories/scanner_repository.dart';
import 'package:qr_toolkit/features/scanner/data/datasource/scanner_local_datasource.dart';
import 'package:qr_toolkit/features/scanner/data/models/scan_result_model.dart';

class ScannerRepositoryImpl implements ScannerRepository {
  ScannerRepositoryImpl(this._dataSource);

  final ScannerLocalDataSource _dataSource;

  @override
  Future<List<ScanResult>> getRecentScans() async {
    try {
      final models = await _dataSource.getScans();
      return models.map((m) => m.toEntity()).toList();
    } on Exception {
      throw const CacheFailure('Could not load scans');
    }
  }

  @override
  Future<void> saveScan(ScanResult scan) async {
    await _dataSource.saveScan(ScanResultModel.fromEntity(scan));
  }

  @override
  Future<void> deleteScan(String id) => _dataSource.deleteScan(id);

  @override
  Future<void> clearScans() => _dataSource.clear();
}
