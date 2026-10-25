import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';

abstract class ScannerRepository {
  Future<List<ScanResult>> getRecentScans();
  Future<void> saveScan(ScanResult scan);
  Future<void> deleteScan(String id);
  Future<void> clearScans();
}
