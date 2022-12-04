import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'whitelist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late WatchlistTvNotifier provider;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    provider = WatchlistTvNotifier(getWatchlistTv: mockGetWatchlistTv);
  });

  group('watchlist tv notifier', () {
    test(
      'should get data with success state and not null',
      () async {
        when(mockGetWatchlistTv.execute()).thenAnswer(
          (_) async => Right(testTvList),
        );

        await provider.fetchWatchlistMovies();

        verify(mockGetWatchlistTv.execute());
        expect(provider.watchlistState, RequestState.Loaded);
        expect(provider.watchlistTv, isNotEmpty);
      },
    );

    test(
      'should get watchlist tv with empty data',
      () async {
        when(mockGetWatchlistTv.execute()).thenAnswer(
          (_) async => Right([]),
        );

        await provider.fetchWatchlistMovies();

        verify(mockGetWatchlistTv.execute());
        expect(provider.watchlistState, RequestState.Loaded);
        expect(provider.watchlistTv, isEmpty);
      },
    );

    test(
      'should get error DatabaseFailure',
      () async {
        when(mockGetWatchlistTv.execute()).thenAnswer(
          (_) async => Left(
            DatabaseFailure('no database found in the device'),
          ),
        );

        await provider.fetchWatchlistMovies();

        verify(mockGetWatchlistTv.execute());
        expect(provider.watchlistState, RequestState.Error);
        expect(provider.message, 'no database found in the device');
      },
    );
  });
}
