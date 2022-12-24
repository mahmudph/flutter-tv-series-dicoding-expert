import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/domain/usecases/search_movies.dart';
import 'package:movie_feature/presentation/bloc/search_movie/search_movie_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late MockSearchMovies mockSearchMovies;
  late SearchMovieCubit searchMovieCubit;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMovieCubit = SearchMovieCubit(searchMovies: mockSearchMovies);
  });

  tearDown(() {
    searchMovieCubit.close();
  });

  const tQuery = 'spidermant';

  group(
    'search movie cubit',
    () {
      blocTest(
        'should get item based query and emit state SearchMovieSuccess',
        build: () => searchMovieCubit,
        setUp: () => when(() => mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => Right(testMovieList),
        ),
        act: (bloc) => bloc.searchMoviesByQuery(tQuery),
        verify: (bloc) => verify(
          () => mockSearchMovies.execute(tQuery),
        ).called(1),
        expect: () => [
          SearchMovieLoading(),
          SearchMovieSuccess(movies: testMovieList),
        ],
      );
      blocTest(
        'should get item based query and emit state SearchmovieFailure',
        build: () => searchMovieCubit,
        setUp: () => when(() => mockSearchMovies.execute(tQuery)).thenAnswer(
          (_) async => const Left(
            ServerFailure('data not found'),
          ),
        ),
        act: (bloc) => bloc.searchMoviesByQuery(tQuery),
        verify: (bloc) => verify(
          () => mockSearchMovies.execute(tQuery),
        ).called(1),
        expect: () => [
          SearchMovieLoading(),
          const SearchMovieFailure(message: 'data not found')
        ],
      );
    },
  );
}
