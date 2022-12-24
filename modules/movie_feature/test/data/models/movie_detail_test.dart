import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_feature/data/models/genre_model.dart';
import 'package:movie_feature/data/models/movie_detail_model.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../json_reader.dart';

void main() {
  /// gendres
  const genre = Genre(id: 1, name: 'Action');

  /// movie details
  const movieDetail = MovieDetail(
    adult: false,
    backdropPath: "/path.jpg",
    genres: [genre],
    id: 1,
    originalTitle: "Original Title",
    overview: "Overview",
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    runtime: 120,
    title: "Title",
    voteAverage: 1.0,
    voteCount: 1,
  );

  const genreModel = GenreModel(id: 1, name: 'Action');

  const movieDetailResponse = MovieDetailResponse(
    adult: false,
    backdropPath: "/path.jpg",
    genres: [genreModel],
    id: 1,
    originalTitle: "Original Title",
    overview: "Overview",
    posterPath: "/path.jpg",
    releaseDate: "2020-05-05",
    runtime: 120,
    title: "Title",
    voteAverage: 1.0,
    voteCount: 1,
    budget: 100,
    homepage: "https://google.com",
    imdbId: "imdb1",
    originalLanguage: 'en',
    popularity: 1.0,
    revenue: 12000,
    status: "Status",
    tagline: "Tagline",
    video: false,
  );

  const movieDetailMap = {
    "adult": false,
    "backdrop_path": "/path.jpg",
    "genres": [
      {'id': 1, 'name': 'Action'}
    ],
    "id": 1,
    "original_title": "Original Title",
    "overview": "Overview",
    "poster_path": "/path.jpg",
    "release_date": "2020-05-05",
    "runtime": 120,
    "title": "Title",
    "vote_average": 1.0,
    "vote_count": 1,
    "budget": 100,
    "homepage": "https://google.com",
    "imdb_id": "imdb1",
    "original_language": 'en',
    "popularity": 1.0,
    "revenue": 12000,
    "status": "Status",
    "tagline": "Tagline",
    "video": false,
  };

  test(
    'should create movie detail from json successfuly',
    () {
      final mapMovieDetail = json.decode(
        readJson('dummy_data/movie_detail.json'),
      );
      final result = MovieDetailResponse.fromJson(mapMovieDetail);
      expect(result, equals(movieDetailResponse));
    },
  );

  test(
    'should transform MovieDetailResponse into MovieDetail entity',
    () {
      final mapMovieDetail = json.decode(
        readJson('dummy_data/movie_detail.json'),
      );
      final result = MovieDetailResponse.fromJson(mapMovieDetail);
      expect(result.toEntity(), equals(movieDetail));
    },
  );

  test(
    'should transform MovieDetailResponse into MovieDetail entity',
    () {
      final mapMovieDetail = json.decode(
        readJson('dummy_data/movie_detail.json'),
      );
      final result = MovieDetailResponse.fromJson(mapMovieDetail);
      expect(result.toJson(), equals(movieDetailMap));
    },
  );
}
