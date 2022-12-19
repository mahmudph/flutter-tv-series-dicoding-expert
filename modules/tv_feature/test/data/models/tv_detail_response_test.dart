import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/tv_detail_response.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';

import '../../json_reader.dart';

void main() {
  group(
    'test tv detail response',
    () {
      test(
        'should parse from json sucessfuly',
        () {
          final actual = TvDetailResponse.fromJson(
            readJson('dummy_data/tv_details.json'),
          );

          expect(actual, isA<TvDetailResponse>());
          expect(actual.id, isNotNull);
        },
      );

      test(
        'should parse from map sucessfuly',
        () {
          final jsonString = readJson('dummy_data/tv_details.json');
          final actual = TvDetailResponse.fromMap(
            json.decode(jsonString),
          );

          expect(actual, isA<TvDetailResponse>());
          expect(actual.id, isNotNull);
        },
      );

      test(
        'should parse to another entyty with sucessfuly',
        () {
          final jsonString = readJson('dummy_data/tv_details.json');
          final detailResponse = TvDetailResponse.fromMap(
            json.decode(jsonString),
          );

          expect(detailResponse.toEntity(), isA<TvDetail>());
          expect(detailResponse.toJson(), isA<String>());
          expect(detailResponse.toMap(), isMap);
        },
      );
    },
  );
}
