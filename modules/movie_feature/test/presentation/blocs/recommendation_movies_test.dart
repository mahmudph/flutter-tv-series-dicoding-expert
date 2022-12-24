import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetRecommendationMovies extends Mock
    implements GetMovieRecommendations {}

void main() {
  late MockGetRecommendationMovies mockGetRecommendationMovies;
  late RecommendationMoviesCubit recommendationMoviesCubit;

  setUp(() {
    mockGetRecommendationMovies = MockGetRecommendationMovies();
    recommendationMoviesCubit = RecommendationMoviesCubit(
      getMovieRecommendations: mockGetRecommendationMovies,
    );
  });

  tearDown(() {
    recommendationMoviesCubit.close();
  });

  const theId = 1;

  group(
    'recommendation cubit',
    () {
      blocTest(
        'should get data movies and emit RecommendationMoviesSuccess',
        setUp: () =>
            when(() => mockGetRecommendationMovies.execute(theId)).thenAnswer(
          (_) async => Right(testMovieList),
        ),
        build: () => recommendationMoviesCubit,
        act: (bloc) => bloc.fetchRecommendationMovies(theId),
        verify: (bloc) => verify(
          () => mockGetRecommendationMovies.execute(theId),
        ).called(1),
        expect: () => [
          RecommendationMoviesLoading(),
          RecommendationMoviesSuccess(movies: testMovieList),
        ],
      );

      blocTest(
        'should get data movies and emit RecommendationMoviesFailure',
        setUp: () =>
            when(() => mockGetRecommendationMovies.execute(theId)).thenAnswer(
          (_) async => const Left(
            ServerFailure('data recommendation noot found'),
          ),
        ),
        build: () => recommendationMoviesCubit,
        act: (bloc) => bloc.fetchRecommendationMovies(theId),
        verify: (bloc) => verify(
          () => mockGetRecommendationMovies.execute(theId),
        ).called(1),
        expect: () => [
          RecommendationMoviesLoading(),
          const RecommendationMoviesFailure(
            message: 'data recommendation noot found',
          ),
        ],
      );
    },
  );
}
