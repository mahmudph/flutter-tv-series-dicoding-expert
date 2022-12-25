import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late PopularMovieCubit popularMovieCubit;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieCubit = PopularMovieCubit(popularMovies: mockGetPopularMovies);
  });

  group(
    'test popular movie',
    () {
      blocTest(
        'get with success',
        setUp: () => when(() => mockGetPopularMovies.execute()).thenAnswer(
          (_) async => Right(testMovieList),
        ),
        build: () => popularMovieCubit,
        act: (bloc) => bloc.fetchPopularMovies(),
        verify: (bloc) => verify(
          () => mockGetPopularMovies.execute(),
        ).called(1),
        expect: () => [
          PopularMovieLoading(),
          PopularMovieSucess(movies: testMovieList),
        ],
      );

      blocTest(
        'get with failure',
        setUp: () => when(() => mockGetPopularMovies.execute()).thenAnswer(
          (_) async => const Left(
            ServerFailure('failed to get data populars movie'),
          ),
        ),
        build: () => popularMovieCubit,
        act: (bloc) => bloc.fetchPopularMovies(),
        verify: (bloc) => verify(
          () => mockGetPopularMovies.execute(),
        ).called(1),
        expect: () => [
          PopularMovieLoading(),
          const PopularMovieFailure(
            message: 'failed to get data populars movie',
          ),
        ],
      );
    },
  );
}
