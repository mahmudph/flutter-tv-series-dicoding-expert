import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/domain/usecases/get_watchlist_tv_status.dart';

import '../../mocks/data_mock.dart';

void main() {
  late MockTvRepository mockTvRepository;
  late GetWatchListTvStatus getWatchlistTv;

  setUp(() {
    mockTvRepository = MockTvRepository();
    getWatchlistTv = GetWatchListTvStatus(mockTvRepository);
  });

  test(
    'should get data watch tv list from the repository',
    () async {
      when(() => mockTvRepository.isAddedToWatchlist(1)).thenAnswer(
        (_) async => true,
      );
      final result = await getWatchlistTv.execute(1);

      verify(() => mockTvRepository.isAddedToWatchlist(1));
      expect(result, equals(true));
    },
  );
}
