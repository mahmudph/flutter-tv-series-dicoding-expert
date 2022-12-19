import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/last_to_air_model.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group(
    'test last air model',
    () {
      final data = {
        "air_date": "2022-10-15",
        "episode_number": 1,
        "id": 21,
        "name": "name",
        "overview": "overview",
        "production_code": "productionCode",
        "season_number": 1,
        "still_path": "stillPath",
        "vote_average": 10.0,
        "vote_count": 1
      };

      test(
        'should parse json with successfuly',
        () {
          final result = LastEpisodeToAirModel.fromMap(data);

          expect(result.airDate, testLastToAirModel.airDate);
          expect(result.id, testLastToAirModel.id);
          expect(result.episodeNumber, testLastToAirModel.episodeNumber);
          expect(result.name, testLastToAirModel.name);
          expect(result.overview, testLastToAirModel.overview);
          expect(result.productionCode, testLastToAirModel.productionCode);
          expect(result.seasonNumber, testLastToAirModel.seasonNumber);
          expect(result.stillPath, testLastToAirModel.stillPath);
          expect(result.voteAverage, testLastToAirModel.voteAverage);
          expect(result.voteCount, testLastToAirModel.voteCount);
        },
      );

      test(
        'should parse from model to map and string json successfuly',
        () {
          final resultAsMap = testLastToAirModel.toMap();
          final resultAsString = testLastToAirModel.toJson();
          expect(resultAsMap, data);
          expect(resultAsString, json.encode(data));
        },
      );

      test(
        'should parse from json  to model successfuly',
        () {
          final result = LastEpisodeToAirModel.fromJson(json.encode(data));

          expect(result.airDate, testLastToAirModel.airDate);
          expect(result.id, testLastToAirModel.id);
          expect(result.episodeNumber, testLastToAirModel.episodeNumber);
          expect(result.name, testLastToAirModel.name);
          expect(result.overview, testLastToAirModel.overview);
          expect(result.productionCode, testLastToAirModel.productionCode);
          expect(result.seasonNumber, testLastToAirModel.seasonNumber);
          expect(result.stillPath, testLastToAirModel.stillPath);
          expect(result.voteAverage, testLastToAirModel.voteAverage);
          expect(result.voteCount, testLastToAirModel.voteCount);
        },
      );
    },
  );
}
