import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_feature/domain/usecases/get_popular_movies.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRpository;

  setUp(() {
    mockMovieRpository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRpository);
  });

  group('GetPopularMovies Tests', () {
    group('execute', () {
      test(
        'should get list of movies from the repository when execute function is called',
        () async {
          // arrange
          when(() => mockMovieRpository.getPopularMovies()).thenAnswer(
            (_) async => Right(testMovieList),
          );

          // act
          final result = await usecase.execute();
          // assert
          expect(result, Right(testMovieList));
        },
      );
    });
  });
}
