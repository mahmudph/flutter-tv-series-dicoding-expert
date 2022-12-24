import 'package:movie_feature/data/models/genre_model.dart';
import 'package:movie_feature/data/models/movie_detail_model.dart';
import 'package:movie_feature/data/models/movie_model.dart';
import 'package:movie_feature/data/models/movie_table.dart';
import 'package:movie_feature/movie_feature.dart';

const tMovieModel = MovieModel(
  adult: false,
  backdropPath: 'backdropPath',
  genreIds: [1, 2, 3],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  title: 'title',
  video: false,
  voteAverage: 1,
  voteCount: 1,
);

const tMovieModelJson = {
  "adult": false,
  "backdrop_path": 'backdropPath',
  "genre_ids": [1, 2, 3],
  "id": 1,
  "original_title": 'originalTitle',
  "overview": 'overview',
  "popularity": 1,
  "poster_path": 'posterPath',
  "release_date": 'releaseDate',
  "title": 'title',
  "video": false,
  "vote_average": 1,
  "vote_count": 1,
};

final tMovie = Movie(
  adult: false,
  backdropPath: 'backdropPath',
  genreIds: const [1, 2, 3],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  title: 'title',
  video: false,
  voteAverage: 1,
  voteCount: 1,
);

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: const [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

const testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

const tMovieResponse = MovieDetailResponse(
  adult: false,
  backdropPath: 'backdropPath',
  budget: 100,
  genres: [
    GenreModel(id: 1, name: 'Action'),
  ],
  homepage: "https://google.com",
  id: 1,
  imdbId: 'imdb1',
  originalLanguage: 'en',
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  revenue: 12000,
  runtime: 120,
  status: 'Status',
  tagline: 'Tagline',
  title: 'title',
  video: false,
  voteAverage: 1,
  voteCount: 1,
);
