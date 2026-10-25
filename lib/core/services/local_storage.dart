import 'package:hive_flutter/hive_flutter.dart';
import 'package:qr_toolkit/core/errors/exceptions.dart';

abstract class LocalStorage {
  Future<void> init();
  Future<void> put(String box, String key, dynamic value);
  dynamic get(String box, String key, {dynamic defaultValue});
  Future<void> delete(String box, String key);
  Future<void> clear(String box);
}

class HiveLocalStorage implements LocalStorage {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<void> put(String box, String key, dynamic value) async {
    try {
      final b = await Hive.openBox(box);
      await b.put(key, value);
    } on Exception catch (e) {
      throw CacheException('Failed to store data: $e');
    }
  }

  @override
  dynamic get(String box, String key, {dynamic defaultValue}) {
    try {
      final b = Hive.box(box);
      return b.get(key, defaultValue: defaultValue);
    } on Exception catch (e) {
      throw CacheException('Failed to read data: $e');
    }
  }

  @override
  Future<void> delete(String box, String key) async {
    final b = await Hive.openBox(box);
    await b.delete(key);
  }

  @override
  Future<void> clear(String box) async {
    final b = await Hive.openBox(box);
    await b.clear();
  }
}
