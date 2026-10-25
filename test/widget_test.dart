import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:qr_toolkit/core/services/local_storage.dart';
import 'package:qr_toolkit/features/settings/presentation/controller/settings_controller.dart';
import 'package:qr_toolkit/main.dart';

class FakeLocalStorage implements LocalStorage {
  final Map<String, Map<String, dynamic>> _store = {};

  @override
  Future<void> init() async {}

  @override
  Future<void> put(String box, String key, dynamic value) async {
    _store.putIfAbsent(box, () => {});
    _store[box]![key] = value;
  }

  @override
  dynamic get(String box, String key, {dynamic defaultValue}) {
    return _store[box]?[key] ?? defaultValue;
  }

  @override
  Future<void> delete(String box, String key) async {
    _store[box]?.remove(key);
  }

  @override
  Future<void> clear(String box) async {
    _store[box]?.clear();
  }
}

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    final fakeStorage = FakeLocalStorage();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsControllerProvider.overrideWith(
            (ref) => SettingsController(fakeStorage),
          ),
        ],
        child: const QrToolkitApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
