import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_toolkit/core/constants/app_constants.dart';
import 'package:qr_toolkit/core/dependency_injection/injection.dart';
import 'package:qr_toolkit/core/services/local_storage.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
  (ref) => SettingsController(sl<LocalStorage>()),
);

class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.dark,
    this.languageCode = 'en',
    this.biometricEnabled = false,
    this.dynamicColors = false,
  });

  final ThemeMode themeMode;
  final String languageCode;
  final bool biometricEnabled;
  final bool dynamicColors;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    bool? biometricEnabled,
    bool? dynamicColors,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      dynamicColors: dynamicColors ?? this.dynamicColors,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(this._storage) : super(const SettingsState()) {
    _load();
  }

  final LocalStorage _storage;

  Future<void> _load() async {
    final themeIndex = _storage.get(
      AppConstants.hiveBoxSettings,
      'themeMode',
      defaultValue: ThemeMode.dark.index,
    ) as int;
    final lang = _storage.get(
      AppConstants.hiveBoxSettings,
      'lang',
      defaultValue: 'en',
    ) as String;
    final biometric = _storage.get(
      AppConstants.hiveBoxSettings,
      'biometric',
      defaultValue: false,
    ) as bool;
    final dynamic = _storage.get(
      AppConstants.hiveBoxSettings,
      'dynamic',
      defaultValue: false,
    ) as bool;
    state = SettingsState(
      themeMode: ThemeMode.values[themeIndex],
      languageCode: lang,
      biometricEnabled: biometric,
      dynamicColors: dynamic,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _storage.put(
      AppConstants.hiveBoxSettings,
      'themeMode',
      mode.index,
    );
  }

  Future<void> setLanguage(String code) async {
    state = state.copyWith(languageCode: code);
    await _storage.put(AppConstants.hiveBoxSettings, 'lang', code);
  }

  Future<void> setBiometric(bool enabled) async {
    state = state.copyWith(biometricEnabled: enabled);
    await _storage.put(
      AppConstants.hiveBoxSettings,
      'biometric',
      enabled,
    );
  }

  Future<void> setDynamicColors(bool enabled) async {
    state = state.copyWith(dynamicColors: enabled);
    await _storage.put(
      AppConstants.hiveBoxSettings,
      'dynamic',
      enabled,
    );
  }
}
