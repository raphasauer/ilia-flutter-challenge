import 'package:hive/hive.dart';

class CacheService {
  final String cacheName;
  final Box _box;

  CacheService({
    required this.cacheName,
    Box? box,
  }) : _box = box ?? Hive.box(cacheName);

  dynamic getCachedData(String key) {
    return _box.get(key);
  }

  void putCachedData(String key, dynamic value) {
    _box.put(key, value);
  }
}
