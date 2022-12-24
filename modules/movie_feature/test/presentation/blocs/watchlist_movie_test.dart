import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchlist extends Mock implements GetWatchlistMovies {}

void main() {
  late MockGetWatchlist mockGetWatchlist;

  late WatchlistMovieCubit watchlistMovieCubit;

  setUp(() {
    mockGetWatchlist = MockGetWatchlist();
    watchlistMovieCubit = WatchlistMovieCubit(
      getWatchlistMovies: mockGetWatchlist,
    );
  });

  tearDown(() {
    watchlistMovieCubit.close();
  });

  group(
    'recommendation cubit',
    () {
      blocTest(
        'should get data movies and emit TopRatedMoviesSuccess',
        setUp: () => when(() => mockGetWatchlist.execute()).thenAnswer(
          (_) async => Right(testMovieList),
        ),
        build: () => watchlistMovieCubit,
        act: (bloc) => bloc.loadMovieWatchlist(),
        verify: (bloc) => verify(
          () => mockGetWatchlist.execute(),
        ).called(1),
        expect: () => [
          WatchlistMovieLoading(),
          WatchlistMovieDataSuccess(movies: testMovieList),
        ],
      );

      blocTest(
        'should get data movies and emit TopRatedMoviesFailure',
        setUp: () => when(() => mockGetWatchlist.execute()).thenAnswer(
          (_) async => const Left(
            ServerFailure('data recommendation noot found'),
          ),
        ),
        build: () => watchlistMovieCubit,
        act: (bloc) => bloc.loadMovieWatchlist(),
        verify: (bloc) => verify(
          () => mockGetWatchlist.execute(),
        ).called(1),
        expect: () => [
          WatchlistMovieLoading(),
          const WatchlistMovieFailure(
            message: 'data recommendation noot found',
          ),
        ],
      );
    },
  );
}
