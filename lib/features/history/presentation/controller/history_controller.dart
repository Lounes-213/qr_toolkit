import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/features/history/data/repositories/history_repository.dart';
import 'package:qr_toolkit/features/history/data/repositories/history_repository_impl.dart';
import 'package:qr_toolkit/features/history/domain/usecases/export_json.dart';
import 'package:qr_toolkit/features/scanner/domain/entities/scan_result.dart';
import 'package:qr_toolkit/shared/enums/qr_content_type.dart';

enum SortMode { dateDesc, dateAsc }

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepositoryImpl(),
);

final exportJsonProvider = Provider<ExportJson>((ref) => const ExportJson());

final historyControllerProvider =
    StateNotifierProvider<HistoryController, HistoryState>(
  (ref) => HistoryController(
    ref.watch(historyRepositoryProvider),
    ref.watch(exportJsonProvider),
  ),
);

class HistoryState {
  const HistoryState({
    this.scans = const [],
    this.searchQuery = '',
    this.filter,
    this.sort = SortMode.dateDesc,
    this.favoriteIds = const [],
    this.isLoading = false,
  });

  final List<ScanResult> scans;
  final String searchQuery;
  final QrContentType? filter;
  final SortMode sort;
  final List<String> favoriteIds;
  final bool isLoading;

  HistoryState copyWith({
    List<ScanResult>? scans,
    String? searchQuery,
    QrContentType? filter,
    bool clearFilter = false,
    SortMode? sort,
    List<String>? favoriteIds,
    bool? isLoading,
  }) {
    return HistoryState(
      scans: scans ?? this.scans,
      searchQuery: searchQuery ?? this.searchQuery,
      filter: clearFilter ? null : (filter ?? this.filter),
      sort: sort ?? this.sort,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<ScanResult> get filteredScans {
    var list = List<ScanResult>.from(scans);
    if (filter != null) {
      list = list.where((s) => s.type == filter).toList();
    }
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where((s) => s.content.toLowerCase().contains(query))
          .toList();
    }
    list.sort((a, b) => sort == SortMode.dateDesc
        ? b.scannedAt.compareTo(a.scannedAt)
        : a.scannedAt.compareTo(b.scannedAt));
    return list;
  }

  List<ScanResult> get favoriteScans =>
      scans.where((s) => favoriteIds.contains(s.id)).toList();
}

class HistoryController extends StateNotifier<HistoryState> {
  HistoryController(this._repository, this._exportJson)
      : super(const HistoryState());

  final HistoryRepository _repository;
  final ExportJson _exportJson;

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    final scans = await _repository.getScans();
    final favoriteIds = await _repository.getFavoriteIds();
    state = state.copyWith(
      scans: scans,
      favoriteIds: favoriteIds,
      isLoading: false,
    );
  }

  void onSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilter(QrContentType? filter) {
    state = state.copyWith(filter: filter, clearFilter: filter == null);
  }

  void setSort(SortMode sort) {
    state = state.copyWith(sort: sort);
  }

  Future<void> delete(String id) async {
    await _repository.deleteScan(id);
    state = state.copyWith(
      scans: state.scans.where((s) => s.id != id).toList(),
    );
  }

  Future<void> toggleFavorite(String id) async {
    final favoriteIds = await _repository.toggleFavorite(id);
    state = state.copyWith(favoriteIds: favoriteIds);
  }

  Future<void> clearAll() async {
    await _repository.clearScans();
    state = state.copyWith(scans: []);
  }

  String exportJson() => _exportJson(state.scans);
}
