import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

class MockGetWatchlistStatus extends Mock implements GetWatchListStatus {}

void main() {
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late MockGetWatchlistStatus mockGetWatchliststatus;
  late WatchlistMovieStatusCubit watchlistMovieStatusCubit;

  const tMovieId = 1;

  setUp(() {
    mockSaveWatchlist = MockSaveWatchlist();
    mockGetWatchliststatus = MockGetWatchlistStatus();
    mockRemoveWatchlist = MockRemoveWatchlist();

    watchlistMovieStatusCubit = WatchlistMovieStatusCubit(
      getWatchListStatus: mockGetWatchliststatus,
      removeWatchlist: mockRemoveWatchlist,
      saveWatchlist: mockSaveWatchlist,
    );
  });

  tearDown(() {
    watchlistMovieStatusCubit.close();
  });

  group(
    'save to watchlist',
    () {
      blocTest(
        'should fialure and get the message',
        setUp: () => when(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer(
          (_) async => const Right('success add into watchlist'),
        ),
        build: () => watchlistMovieStatusCubit,
        act: (bloc) => bloc.addWatchlist(testMovieDetail),
        verify: (bloc) => verify(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).called(1),
        expect: () => [
          const WatchlistMovieStatusData(
            isAddToWatchlist: true,
            message: 'success add into watchlist',
          ),
        ],
      );

      blocTest(
        'should get data movies and emit WatchlistMovieStatusData',
        setUp: () => when(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer(
          (_) async => const Left(
            DatabaseFailure('failed to add into watchlist'),
          ),
        ),
        build: () => watchlistMovieStatusCubit,
        act: (bloc) => bloc.addWatchlist(testMovieDetail),
        verify: (bloc) => verify(
          () => mockSaveWatchlist.execute(testMovieDetail),
        ).called(1),
        expect: () => [
          const WatchlistMovieStatusData(
            isAddToWatchlist: false,
            message: 'failed to add into watchlist',
          ),
        ],
      );
    },
  );

  group(
    'remove from watchlist',
    () {
      blocTest(
        'should success',
        setUp: () => when(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).thenAnswer(
          (_) async => const Right('success remove from watchlist'),
        ),
        build: () => watchlistMovieStatusCubit,
        act: (bloc) => bloc.removeFromWatchlist(testMovieDetail),
        verify: (bloc) => verify(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).called(1),
        expect: () => [
          const WatchlistMovieStatusData(
            isAddToWatchlist: false,
            message: 'success remove from watchlist',
          ),
        ],
      );

      blocTest(
        'should throw DatabaseFailure and get message',
        setUp: () => when(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).thenAnswer(
          (_) async => const Left(
            DatabaseFailure('failed to remove from watchlist'),
          ),
        ),
        build: () => watchlistMovieStatusCubit,
        act: (bloc) => bloc.removeFromWatchlist(testMovieDetail),
        verify: (bloc) => verify(
          () => mockRemoveWatchlist.execute(testMovieDetail),
        ).called(1),
        expect: () => [
          const WatchlistMovieStatusData(
            isAddToWatchlist: true,
            message: 'failed to remove from watchlist',
          ),
        ],
      );
    },
  );

  group(
    'get movies from watchlist',
    () {
      blocTest(
        'should success',
        setUp: () => when(
          () => mockGetWatchliststatus.execute(tMovieId),
        ).thenAnswer(
          (_) async => true,
        ),
        build: () => watchlistMovieStatusCubit,
        act: (bloc) => bloc.loadWatchlistStatus(tMovieId),
        verify: (bloc) => verify(
          () => mockGetWatchliststatus.execute(tMovieId),
        ).called(1),
        expect: () => [
          const WatchlistMovieStatusData(
            isAddToWatchlist: true,
            message: '',
          ),
        ],
      );

      blocTest(
        'should throw DatabaseFailure and get message',
        setUp: () => when(
          () => mockGetWatchliststatus.execute(tMovieId),
        ).thenAnswer(
          (_) async => false,
        ),
        build: () => watchlistMovieStatusCubit,
        act: (bloc) => bloc.loadWatchlistStatus(tMovieId),
        verify: (bloc) => verify(
          () => mockGetWatchliststatus.execute(tMovieId),
        ).called(1),
        expect: () => [
          const WatchlistMovieStatusData(
            isAddToWatchlist: false,
            message: '',
          ),
        ],
      );
    },
  );
}
