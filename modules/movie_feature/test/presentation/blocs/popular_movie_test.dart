import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late PopularMovieCubit popularMovieCubit;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieCubit = PopularMovieCubit(popularMovies: mockGetPopularMovies);
  });


  group(
    'test popular movie', () {

    },
  );
}
