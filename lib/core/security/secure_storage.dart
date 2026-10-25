import 'dart:io';
import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Encrypted local storage backed by Hive.
///
/// The AES key is persisted in the app documents directory. For maximum
/// protection it should instead be held in the OS keystore
/// (flutter_secure_storage); this implementation provides the encrypted-box
/// layer and a working key holder that can be swapped later.
abstract class SecureStorage {
  Future<void> init();
  Future<void> write(String key, String value);
  String? read(String key);
  Future<void> delete(String key);
  Future<void> clear();
}

class HiveSecureStorage implements SecureStorage {
  HiveSecureStorage(this._boxName);

  final String _boxName;
  late List<int> _key;

  @override
  Future<void> init() async {
    _key = await _loadKey();
  }

  Future<List<int>> _loadKey() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_boxName.key');
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      if (bytes.length == 32) return bytes;
    }
    final key = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    await file.writeAsBytes(key);
    return key;
  }

  Future<Box> get _box async => Hive.openBox(
        _boxName,
        encryptionCipher: HiveAesCipher(_key),
      );

  @override
  Future<void> write(String key, String value) async {
    final box = await _box;
    await box.put(key, value);
  }

  @override
  String? read(String key) {
    final box = Hive.box(_boxName);
    return box.get(key) as String?;
  }

  @override
  Future<void> delete(String key) async {
    final box = await _box;
    await box.delete(key);
  }

  @override
  Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}
