import 'package:flutter_test/flutter_test.dart';
import 'package:movie_feature/data/models/movie_table.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  /// create new object from class model MovieTable
  ///
  const movieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  test(
    'should transform to the movie enity successfully',
    () {
      /// expected movie
      final expectedMovie = Movie.watchlist(
        id: 1,
        overview: 'overview',
        posterPath: 'posterPath',
        title: 'title',
      );

      final result = movieTable.toEntity();
      expect(result, expectedMovie);
    },
  );

  test(
    'should transform to the movie json Map<String,dynamic> successfully',
    () {
      /// expected movie
      final expectedMovie = {
        'id': 1,
        'overview': 'overview',
        'posterPath': 'posterPath',
        'title': 'title',
      };

      final result = movieTable.toJson();
      expect(result, expectedMovie);
    },
  );

  test(
    'should create movie table from movie entity successfully',
    () {
      final result = MovieTable.fromEntity(testMovieDetail);

      expect(result.id, testMovieDetail.id);
      expect(result.overview, testMovieDetail.overview);
      expect(result.title, testMovieDetail.title);
    },
  );

  test(
    'should create movie table from movie entity successfully',
    () {
      final movieMap = {
        'id': 1,
        'overview': 'overview',
        'posterPath': 'posterPath',
        'title': 'title',
      };

      final result = MovieTable.fromMap(movieMap);

      expect(result.id, movieMap['id']);
      expect(result.overview, movieMap['overview']);
      expect(result.title, movieMap['title']);
      expect(result.posterPath, movieMap['posterPath']);
    },
  );
}
