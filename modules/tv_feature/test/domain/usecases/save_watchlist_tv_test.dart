import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/domain/usecases/save_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late SaveWatchlistTv saveWatchlistTv;

  setUp(() {
    mockTvRepository = MockTvRepository();
    saveWatchlistTv = SaveWatchlistTv(mockTvRepository);
  });

  test(
    'should save data tv into into watchlist',
    () async {
      when(() => mockTvRepository.saveWatchlist(testTvDetail)).thenAnswer(
        (_) async => const Right('Success to save tv into watchlist'),
      );
      final result = await saveWatchlistTv.execute(testTvDetail);

      verify(() => mockTvRepository.saveWatchlist(testTvDetail));
      expect(result, const Right('Success to save tv into watchlist'));
    },
  );
}
