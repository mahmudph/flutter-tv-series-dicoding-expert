import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/domain/usecases/remove_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late RemoveWatchlistTv removeWatchlistTv;

  setUp(() {
    mockTvRepository = MockTvRepository();
    removeWatchlistTv = RemoveWatchlistTv(mockTvRepository);
  });

  test(
    'should remmove data watch tv list from the repository',
    () async {
      when(() => mockTvRepository.removeWatchlist(testTvDetail)).thenAnswer(
        (_) async => const Right('Success to remove tv from watchlist'),
      );
      final result = await removeWatchlistTv.execute(testTvDetail);

      verify(() => mockTvRepository.removeWatchlist(testTvDetail));
      expect(result, const Right('Success to remove tv from watchlist'));
    },
  );
}
