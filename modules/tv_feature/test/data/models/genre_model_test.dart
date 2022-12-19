import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/genre_model.dart';
import 'package:tv_feature/domain/entitas/genre.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  group('test genre model', () {
    test(
      'should parse from json successfully',
      () {
        final jsonMap = json.decode(readJson('dummy_data/genre.json'));
        final actual = GenreModel.fromJson(jsonMap as Map<String, dynamic>);

        expect(actual.id, testGenreModel.id);
        expect(actual.name, testGenreModel.name);
      },
    );

    test(
      'should parse to json successfully',
      () {
        final expected = json.decode(readJson('dummy_data/genre.json'));
        final actual = testGenreModel.toJson();
        expect(actual, expected);
      },
    );

    test(
      'should parse to entity successfully',
      () {
        final actual = testGenreModel.toEntity();
        const expectedValue = Genre(id: 1, name: 'name');

        expect(expectedValue.id, actual.id);
        expect(expectedValue.name, actual.name);
      },
    );
  });
}
