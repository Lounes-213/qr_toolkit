import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/dependency_injection/injection.dart';
import 'package:qr_toolkit/core/errors/failures.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/features/scanner/domain/usecases/import_from_gallery.dart';
import 'package:qr_toolkit/features/scanner/domain/usecases/scan_qr.dart';

final scannerControllerProvider =
    StateNotifierProvider<ScannerController, ScannerState>(
  (ref) => ScannerController(sl(), sl()),
);

enum ScannerStatus { initial, loading, success, error }

class ScannerState {
  const ScannerState({
    this.status = ScannerStatus.initial,
    this.scans = const [],
    this.lastResult,
    this.errorMessage,
  });

  final ScannerStatus status;
  final List<ScanResult> scans;
  final ScanResult? lastResult;
  final String? errorMessage;

  ScannerState copyWith({
    ScannerStatus? status,
    List<ScanResult>? scans,
    ScanResult? lastResult,
    String? errorMessage,
  }) {
    return ScannerState(
      status: status ?? this.status,
      scans: scans ?? this.scans,
      lastResult: lastResult ?? this.lastResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ScannerController extends StateNotifier<ScannerState> {
  ScannerController(this._scanQr, this._importFromGallery)
      : super(const ScannerState());

  final ScanQr _scanQr;
  final ImportFromGallery _importFromGallery;

  Future<void> loadScans(List<ScanResult> existing) async {
    state = state.copyWith(status: ScannerStatus.loading);
    state = state.copyWith(status: ScannerStatus.success, scans: existing);
  }

  Future<void> onDetect(String rawValue) async {
    final result = await _scanQr(rawValue);
    state = state.copyWith(
      status: ScannerStatus.success,
      lastResult: result,
      scans: [result, ...state.scans],
    );
  }

  Future<void> importFromGallery() async {
    state = state.copyWith(status: ScannerStatus.loading);
    try {
      final result = await _importFromGallery();
      state = state.copyWith(
        status: ScannerStatus.success,
        lastResult: result,
        scans: [result, ...state.scans],
      );
    } on Failure catch (f) {
      state = state.copyWith(status: ScannerStatus.error, errorMessage: f.message);
    } catch (e) {
      state = state.copyWith(
        status: ScannerStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
