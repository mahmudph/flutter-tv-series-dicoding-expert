import 'package:flutter_test/flutter_test.dart';
import 'package:movie_feature/data/models/movie_model.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });

  test('should success when transform to json', () {
    final result = tMovieModel.toJson();
    expect(result, tMovieModelJson);
  });

  test('should success to create movieModel from json', () {
    final result = MovieModel.fromJson(tMovieModelJson);
    expect(result, tMovieModel);
  });
}
