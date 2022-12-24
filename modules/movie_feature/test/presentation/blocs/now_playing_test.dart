import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMovieCubit nowPlayingMovieCubit;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMovieCubit = NowPlayingMovieCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
    );
  });

  tearDown(() {
    nowPlayingMovieCubit.close();
  });

  group(
    'test movie detail',
    () {
      blocTest(
        'should get movie detail with success and emit state NowPlayingMovieSucess',
        build: () => nowPlayingMovieCubit,
        setUp: () => when(
          () => mockGetNowPlayingMovies.execute(),
        ).thenAnswer(
          (_) async => Right(testMovieList),
        ),
        act: (cubit) => cubit.fetchNowPlayingMovie(),
        verify: (cubit) => verify(
          () => mockGetNowPlayingMovies.execute(),
        ).called(1),
        expect: () => [
          NowPlayingMovieLoading(),
          NowPlayingMovieSucess(movies: testMovieList),
        ],
      );

      blocTest(
        'should get movie detail with failure and emit state ',
        build: () => nowPlayingMovieCubit,
        setUp: () => when(
          () => mockGetNowPlayingMovies.execute(),
        ).thenAnswer(
          (_) async => const Left(
            ConnectionFailure('data detail not found'),
          ),
        ),
        act: (cubit) => cubit.fetchNowPlayingMovie(),
        verify: (cubit) => verify(
          () => mockGetNowPlayingMovies.execute(),
        ).called(1),
        expect: () => [
          NowPlayingMovieLoading(),
          const NowPlayingMovieFailure(message: 'data detail not found'),
        ],
      );
    },
  );
}
