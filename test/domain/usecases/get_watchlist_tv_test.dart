import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetWatchlistTv getWatchlistTv;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getWatchlistTv = GetWatchlistTv(mockTvRepository);
  });

  test(
    'should get data watch tv list from the repository',
    () async {
      when(mockTvRepository.getWatchlistTvs()).thenAnswer(
        (_) async => Right(testTvList),
      );
      final result = await getWatchlistTv.execute();

      verify(mockTvRepository.getWatchlistTvs());
      expect(result, Right(testTvList));
    },
  );
}
