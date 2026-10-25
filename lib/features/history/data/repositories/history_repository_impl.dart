import 'package:hive_flutter/hive_flutter.dart';

import 'package:qr_toolkit/core/constants/app_constants.dart';
import 'package:qr_toolkit/features/history/data/repositories/history_repository.dart';
import 'package:qr_toolkit/features/scanner/data/models/scan_result_model.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl({
    this.favoritesBoxName = 'favorites_box',
  });

  final String favoritesBoxName;

  Future<Box> get _scansBox async =>
      Hive.openBox(AppConstants.hiveBoxScans);
  Future<Box> get _favoritesBox async => Hive.openBox(favoritesBoxName);

  @override
  Future<List<ScanResult>> getScans() async {
    final box = await _scansBox;
    final models = box.values
        .map((e) => ScanResultModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    models.sort((a, b) => b.scannedAtMillis.compareTo(a.scannedAtMillis));
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deleteScan(String id) async {
    final box = await _scansBox;
    await box.delete(id);
  }

  @override
  Future<void> clearScans() async {
    final box = await _scansBox;
    await box.clear();
  }

  @override
  Future<List<String>> getFavoriteIds() async {
    final box = await _favoritesBox;
    return box.keys
        .where((k) => box.get(k) == true)
        .map((k) => k.toString())
        .toList();
  }

  @override
  Future<List<String>> toggleFavorite(String id) async {
    final box = await _favoritesBox;
    if (box.get(id) == true) {
      await box.delete(id);
    } else {
      await box.put(id, true);
    }
    return getFavoriteIds();
  }

  @override
  Future<bool> isFavorite(String id) async {
    final box = await _favoritesBox;
    return box.get(id) == true;
  }
}
