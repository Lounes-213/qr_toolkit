import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';

abstract class HistoryRepository {
  Future<List<ScanResult>> getScans();
  Future<void> deleteScan(String id);
  Future<void> clearScans();

  Future<List<String>> getFavoriteIds();
  Future<List<String>> toggleFavorite(String id);
  Future<bool> isFavorite(String id);
}
