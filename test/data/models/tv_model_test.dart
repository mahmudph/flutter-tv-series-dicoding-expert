import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.now();
  final tvModel = TvModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: now,
    name: 'name',
    originCountry: ['usa'],
    originalLanguage: 'en',
    originalName: 'originalName',
  );

  final tV = Tv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: now,
    name: 'name',
    originCountry: ['usa'],
    originalLanguage: 'en',
    originalName: 'originalName',
  );

  test('should be a subclass of Tv entity', () async {
    final result = tvModel.toEntity();
    expect(result, tV);
  });
}
