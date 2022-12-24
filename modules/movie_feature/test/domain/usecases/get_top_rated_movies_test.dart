import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/domain/usecases/get_top_rated_movies.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late GetTopRatedMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedMovies(mockMovieRepository);
  });

  test('should get list of movies from repository', () async {
    // arrange
    when(() => mockMovieRepository.getTopRatedMovies()).thenAnswer(
      (_) async => Right(testMovieList),
    );

    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testMovieList));
  });
}
