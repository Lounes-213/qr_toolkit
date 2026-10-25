import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/features/export/data/export_repository_impl.dart';
import 'package:qr_toolkit/features/export/domain/export_repository.dart';
import 'package:qr_toolkit/shared/models/qr_model.dart';

final exportRepositoryProvider = Provider<ExportRepository>(
  (ref) => ExportRepositoryImpl(),
);

class ExportState {
  const ExportState({this.isExporting = false, this.lastPath});

  final bool isExporting;
  final String? lastPath;

  ExportState copyWith({bool? isExporting, String? lastPath}) {
    return ExportState(
      isExporting: isExporting ?? this.isExporting,
      lastPath: lastPath ?? this.lastPath,
    );
  }
}

final exportControllerProvider =
    StateNotifierProvider<ExportController, ExportState>(
  (ref) => ExportController(ref.watch(exportRepositoryProvider)),
);

class ExportController extends StateNotifier<ExportState> {
  ExportController(this._repository) : super(const ExportState());

  final ExportRepository _repository;

  Future<void> savePng(Uint8List png) async {
    await _run(() async {
      final file = await _repository.saveFile(png, _fileName('png'), 'image/png');
      state = state.copyWith(lastPath: file.path);
    });
  }

  Future<void> sharePng(Uint8List png) async {
    await _run(() async {
      final file = await _repository.saveFile(png, _fileName('png'), 'image/png');
      await _repository.shareFile(file.path);
    });
  }

  Future<void> saveJpeg(Uint8List jpeg) async {
    await _run(() async {
      final file = await _repository.saveFile(jpeg, _fileName('jpg'), 'image/jpeg');
      state = state.copyWith(lastPath: file.path);
    });
  }

  Future<void> shareJpeg(Uint8List jpeg) async {
    await _run(() async {
      final file = await _repository.saveFile(jpeg, _fileName('jpg'), 'image/jpeg');
      await _repository.shareFile(file.path);
    });
  }

  Future<void> buildAndShareSvg(QrModel model) async {
    await _run(() async {
      final svg = _repository.buildSvg(model);
      final bytes = Uint8List.fromList(svg.codeUnits);
      final file =
          await _repository.saveFile(bytes, _fileName('svg'), 'image/svg+xml');
      await _repository.shareFile(file.path);
    });
  }

  Future<void> buildAndSharePdf(Uint8List png) async {
    await _run(() async {
      final pdf = await _repository.buildPdf(png);
      final file =
          await _repository.saveFile(pdf, _fileName('pdf'), 'application/pdf');
      await _repository.shareFile(file.path);
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    state = state.copyWith(isExporting: true);
    try {
      await action();
    } finally {
      state = state.copyWith(isExporting: false);
    }
  }

  String _fileName(String ext) =>
      'qr_${DateTime.now().microsecondsSinceEpoch}.$ext';
}
