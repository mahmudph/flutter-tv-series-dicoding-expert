import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/session_model.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  group('test session model', () {
    test(
      'from json',
      () {
        final result = SeasonModel.fromJson(
          readJson('dummy_data/seasson.json'),
        );

        expect(result.id, testSeasson.id);
        expect(result.airDate, testSeasson.airDate);
        expect(result.name, testSeasson.name);
        expect(result.overview, testSeasson.overview);
        expect(result.posterPath, testSeasson.posterPath);
        expect(result.seasonNumber, testSeasson.seasonNumber);
        expect(result.episodeCount, testSeasson.episodeCount);
      },
    );

    test('from map', () {
      final result = SeasonModel.fromMap(testSeassonMap);

      expect(result.id, testSeasson.id);
      expect(result.airDate, testSeasson.airDate);
      expect(result.name, testSeasson.name);
      expect(result.overview, testSeasson.overview);
      expect(result.posterPath, testSeasson.posterPath);
      expect(result.seasonNumber, testSeasson.seasonNumber);
      expect(result.episodeCount, testSeasson.episodeCount);
    });

    test('to map', () {
      final result = testSeasson.toMap();

      expect(result['id'], testSeasson.id);
      expect(result['air_date'], testSeasson.airDate);
      expect(result['name'], testSeasson.name);
      expect(result['overview'], testSeasson.overview);
      expect(result['poster_path'], testSeasson.posterPath);
      expect(result['season_number'], testSeasson.seasonNumber);
      expect(result['episode_count'], testSeasson.episodeCount);
    });

    test('to entity', () {
      final result = testSeasson.toEntity();

      expect(result.id, testSeasson.id);
      expect(result.airDate, testSeasson.airDate);
      expect(result.name, testSeasson.name);
      expect(result.overview, testSeasson.overview);
      expect(result.posterPath, testSeasson.posterPath);
      expect(result.seasonNumber, testSeasson.seasonNumber);
      expect(result.episodeCount, testSeasson.episodeCount);
    });

    test('to string json', () {
      final actual = testSeasson.toJson();

      final expected = json.decode(readJson('dummy_data/seasson.json'));
      expect(actual, json.encode(expected));
    });
  });
}
