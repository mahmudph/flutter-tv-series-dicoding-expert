import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/domain/usecases/get_now_playing_movies.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/mocks.dart';


void main() {
  late GetNowPlayingMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetNowPlayingMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(() => mockMovieRepository.getNowPlayingMovies()).thenAnswer(
      (_) async => Right(testMovieList),
    );

    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testMovieList));
  });
}
