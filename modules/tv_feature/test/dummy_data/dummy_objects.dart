import 'package:tv_feature/data/models/genre_model.dart';
import 'package:tv_feature/data/models/last_to_air_model.dart';
import 'package:tv_feature/data/models/session_model.dart';
import 'package:tv_feature/data/models/tv_table.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTv = Tv(
  backdropPath: 'backdropPath',
  firstAirDate: "2021-05-23",
  genreIds: const [1, 2, 3],
  id: 1,
  name: 'name',
  originCountry: const ['en'],
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 1.0,
  posterPath: 'posterPath',
  voteAverage: 1.0,
  voteCount: 1,
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  backdropPath: 'backdropPath',
  episodeRunTime: const [1],
  firstAirDate: DateTime.parse('2010-22-10'),
  genres: const [],
  homepage: 'homepage',
  id: 1,
  inProduction: true,
  languages: const ['languages'],
  lastAirDate: DateTime.parse('2010-22-10'),
  name: 'name',
  nextEpisodeToAir: 'nextEpisodeToAir',
  numberOfEpisodes: 12,
  numberOfSeasons: 12,
  originCountry: const ['originCountry'],
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 3.2,
  posterPath: 'posterPath',
  seasons: const [],
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  voteAverage: 10.0,
  voteCount: 1000,
);

const tvDetailMap = {
  "backdrop_path": 'backdropPath',
  "episode_runTime": [1],
  "first_air_date": '2010-22-10',
  "genres": [],
  "homepage": 'homepage',
  "id": 1,
  "in_production": true,
  "languages": ['languages'],
  "last_air_date": '2010-22-10',
  "name": 'name',
  "next_episode_to_air": 'nextEpisodeToAir',
  "number_of_episodes": 12,
  "number_of_easons": 12,
  "origin_country": ['originCountry'],
  "original_language": 'originalLanguage',
  "original_name": 'originalName',
  "overview": 'overview',
  "popularity": 3.2,
  "poster_path": 'posterPath',
  "seasons": [],
  "status": 'status',
  "tagline": 'tagline',
  "type": 'type',
  "vote_verage": 10.0,
  "vote_ount": 1000,
};

const testTvTable = TvTable(
  id: 1,
  title: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'name',
};

final testWatchlistTv = Tv.watchlist(
  id: 1,
  posterPath: 'posterPath',
  overview: 'overview',
  name: 'name',
);

const testSeasson = SeasonModel(
  airDate: "2010-12-05",
  episodeCount: 64,
  id: 3627,
  name: 'Specials',
  overview: '',
  posterPath: '/kMTcwNRfFKCZ0O2OaBZS0nZ2AIe.jpg',
  seasonNumber: 0,
);

const testSeassonMap = {
  "air_date": "2010-12-05",
  "episode_count": 64,
  "id": 3627,
  "name": 'Specials',
  "overview": '',
  "poster_path": '/kMTcwNRfFKCZ0O2OaBZS0nZ2AIe.jpg',
  "season_number": 0,
};

const testGenreModel = GenreModel(id: 1, name: 'name');

const testGenreModelMap = {
  'id': 1,
  'name': 'name',
};

final testLastToAirModel = LastEpisodeToAirModel(
  airDate: DateTime.parse("2022-10-15"),
  episodeNumber: 1,
  id: 21,
  name: 'name',
  overview: 'overview',
  productionCode: 'productionCode',
  seasonNumber: 1,
  stillPath: "stillPath",
  voteAverage: 10.0,
  voteCount: 1,
);
