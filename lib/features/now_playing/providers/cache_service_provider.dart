import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/cache_service.dart';

final cacheServiceProvider = Provider<CacheService>((ref) {
  return CacheService(cacheName: 'movieDetails');
});
