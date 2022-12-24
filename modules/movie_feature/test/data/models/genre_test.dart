import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_feature/data/models/genre_model.dart';

import '../../json_reader.dart';

void main() {
  group('test genre model', () {
    ///
    /// create genre model
    const testGenre = GenreModel(
      id: 1,
      name: 'name',
    );
    test(
      'should parse from json successfully',
      () {
        final jsonMap = json.decode(readJson('dummy_data/genre.json'));
        final actual = GenreModel.fromJson(jsonMap as Map<String, dynamic>);

        expect(actual.id, testGenre.id);
        expect(actual.name, testGenre.name);
      },
    );

    test(
      'should parse to json successfully',
      () {
        final expected = json.decode(readJson('dummy_data/genre.json'));
        final actual = testGenre.toJson();
        expect(actual, expected);
      },
    );

    test(
      'should parse to entity successfully',
      () {
        final actual = testGenre.toEntity();

        expect(testGenre.id, actual.id);
        expect(testGenre.name, actual.name);
      },
    );
  });
}
