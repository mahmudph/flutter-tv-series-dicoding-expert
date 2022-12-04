import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

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
      when(mockTvRepository.removeWatchlist(testTvDetail)).thenAnswer(
        (_) async => Right('Success to remove tv from watchlist'),
      );
      final result = await removeWatchlistTv.execute(testTvDetail);

      verify(mockTvRepository.removeWatchlist(testTvDetail));
      expect(result, Right('Success to remove tv from watchlist'));
    },
  );
}
