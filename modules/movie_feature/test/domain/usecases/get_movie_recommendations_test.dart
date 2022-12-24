import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_feature/domain/usecases/get_movie_recommendations.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late GetMovieRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetMovieRecommendations(mockMovieRepository);
  });

  const tId = 1;

  test(
    'should get list of movie recommendations from the repository',
    () async {
      // arrange
      when(() => mockMovieRepository.getMovieRecommendations(tId)).thenAnswer(
        (_) async => Right(testMovieList),
      );
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(testMovieList));
    },
  );
}
