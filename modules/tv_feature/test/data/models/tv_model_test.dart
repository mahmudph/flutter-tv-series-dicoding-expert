import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/tv_model.dart';
import 'package:tv_feature/domain/entitas/tv.dart';

void main() {
  const tvModel = TvModel(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: "2022-08-19",
    name: 'name',
    originCountry: ['usa'],
    originalLanguage: 'en',
    originalName: 'originalName',
  );

  final tV = Tv(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAirDate: "2022-08-19",
    name: 'name',
    originCountry: const ['usa'],
    originalLanguage: 'en',
    originalName: 'originalName',
  );

  final actual = {
    "poster_path": "posterPath",
    "popularity": 1.0,
    "id": 1,
    "backdrop_path": "backdropPath",
    "vote_average": 1.0,
    "overview": "overview",
    "first_air_date": "2022-08-19",
    "origin_country": ["usa"],
    "genre_ids": [1, 2, 3],
    "original_language": "en",
    "vote_count": 1,
    "name": "name",
    "original_name": "originalName"
  };

  test('should be a subclass of Tv entity', () async {
    final result = tvModel.toEntity();
    expect(result, tV);
  });

  test('should parse from json and return model', () {
    final result = TvModel.fromMap(actual);

    expect(result, isA<TvModel>());
    expect(result.id, tvModel.id);
    expect(result.name, tvModel.name);
    expect(result.backdropPath, tvModel.backdropPath);
    expect(result.firstAirDate, tvModel.firstAirDate);
    expect(result.genreIds, tvModel.genreIds);
    expect(result.originCountry, tvModel.originCountry);
    expect(result.originalLanguage, tvModel.originalLanguage);
    expect(result.originalName, tvModel.originalName);
    expect(result.popularity, tvModel.popularity);
    expect(result.overview, tvModel.overview);
    expect(result.posterPath, tvModel.posterPath);
  });

  test('should parse from json and return model', () {
    final result = TvModel.fromJson(json.encode(actual));

    expect(result, isA<TvModel>());
    expect(result.id, tvModel.id);
    expect(result.name, tvModel.name);
    expect(result.backdropPath, tvModel.backdropPath);
    expect(result.firstAirDate, tvModel.firstAirDate);
    expect(result.genreIds, tvModel.genreIds);
    expect(result.originCountry, tvModel.originCountry);
    expect(result.originalLanguage, tvModel.originalLanguage);
    expect(result.originalName, tvModel.originalName);
    expect(result.popularity, tvModel.popularity);
    expect(result.overview, tvModel.overview);
    expect(result.posterPath, tvModel.posterPath);
  });

  test(
    'should parse to json string data',
    () {
      final data = tvModel.toJson();
      expect(data, json.encode(actual));
    },
  );
}
