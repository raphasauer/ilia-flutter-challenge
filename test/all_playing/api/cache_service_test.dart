import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';
import 'package:ilia_flutter_challenge/features/now_playing/api/cache_service.dart';

@GenerateNiceMocks([MockSpec<Box>()])
import 'cache_service_test.mocks.dart';

void main() {
  late MockBox mockBox;
  late CacheService cacheService;

  setUp(() {
    mockBox = MockBox();
    cacheService = CacheService(cacheName: 'testCache', box: mockBox);
  });

  group('getCachedData', () {
    test('Should return cached data for a given key', () {
      when(mockBox.get('testKey')).thenReturn('cachedValue');

      final result = cacheService.getCachedData('testKey');

      expect(result, 'cachedValue');
      verify(mockBox.get('testKey')).called(1);
    });

    test('Should return null when there is no cached data for a given key', () {
      when(mockBox.get('testKey')).thenReturn(null);

      final result = cacheService.getCachedData('testKey');

      expect(result, null);
      verify(mockBox.get('testKey')).called(1);
    });
  });

  group('putCachedData', () {
    test('Should store data in cache for a given key', () {
      cacheService.putCachedData('testKey', 'newValue');

      verify(mockBox.put('testKey', 'newValue')).called(1);
    });
  });
}
