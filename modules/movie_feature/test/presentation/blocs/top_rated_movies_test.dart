import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesCubit topRatedMoviesCubit;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesCubit = TopRatedMoviesCubit(
      getTopRatedMovies: mockGetTopRatedMovies,
    );
  });

  tearDown(() {
    topRatedMoviesCubit.close();
  });

  group(
    'recommendation cubit',
    () {
      blocTest(
        'should get data movies and emit TopRatedMoviesSuccess',
        setUp: () => when(() => mockGetTopRatedMovies.execute()).thenAnswer(
          (_) async => Right(testMovieList),
        ),
        build: () => topRatedMoviesCubit,
        act: (bloc) => bloc.fetchTopRatedMovies(),
        verify: (bloc) => verify(
          () => mockGetTopRatedMovies.execute(),
        ).called(1),
        expect: () => [
          TopRatedMoviesLoading(),
          TopRatedMoviesSuccess(movies: testMovieList),
        ],
      );

      blocTest(
        'should get data movies and emit TopRatedMoviesFailure',
        setUp: () => when(() => mockGetTopRatedMovies.execute()).thenAnswer(
          (_) async => const Left(
            ServerFailure('data recommendation noot found'),
          ),
        ),
        build: () => topRatedMoviesCubit,
        act: (bloc) => bloc.fetchTopRatedMovies(),
        verify: (bloc) => verify(
          () => mockGetTopRatedMovies.execute(),
        ).called(1),
        expect: () => [
          TopRatedMoviesLoading(),
          const TopRatedMoviesFailure(
            message: 'data recommendation noot found',
          ),
        ],
      );
    },
  );
}
