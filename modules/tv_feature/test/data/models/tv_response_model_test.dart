import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/tv_model.dart';
import 'package:tv_feature/data/models/tv_response.dart';

import '../../json_reader.dart';

void main() {
  const tvModel = TvModel(
    posterPath: "/vC324sdfcS313vh9QXwijLIHPJp.jpg",
    popularity: 47.432451,
    id: 31917,
    backdropPath: "/rQGBjWNveVeF8f2PGRtS85w9o9r.jpg",
    voteAverage: 5.04,
    overview:
        "Based on the Pretty Little Liars series of young adult novels by Sara Shepard, the series follows the lives of four girls — Spencer, Hanna, Aria, and Emily — whose clique falls apart after the disappearance of their queen bee, Alison. One year later, they begin receiving messages from someone using the name \"A\" who threatens to expose their secrets — including long-hidden ones they thought only Alison knew.",
    firstAirDate: "2010-06-08",
    originCountry: ["US"],
    genreIds: [18, 9648],
    originalLanguage: "en",
    voteCount: 133,
    name: "Pretty Little Liars",
    originalName: "Pretty Little Liars",
  );

  const tVResponseModel = TvResponse(
    results: <TvModel>[tvModel],
    page: 1,
    totalPages: 1,
    totalResults: 1,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/on_the_air_tv.json'),
      );
      // act
      final result = TvResponse.fromMap(jsonMap);
      // assert
      expect(result, tVResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tVResponseModel.toMap();
      // assert
      final expectedJsonMap = {
        "page": 1,
        "total_pages": 1,
        "total_results": 1,
        "results": [
          {
            "poster_path": "/vC324sdfcS313vh9QXwijLIHPJp.jpg",
            "popularity": 47.432451,
            "id": 31917,
            "backdrop_path": "/rQGBjWNveVeF8f2PGRtS85w9o9r.jpg",
            "vote_average": 5.04,
            "overview":
                "Based on the Pretty Little Liars series of young adult novels by Sara Shepard, the series follows the lives of four girls — Spencer, Hanna, Aria, and Emily — whose clique falls apart after the disappearance of their queen bee, Alison. One year later, they begin receiving messages from someone using the name \"A\" who threatens to expose their secrets — including long-hidden ones they thought only Alison knew.",
            "first_air_date": "2010-06-08",
            "origin_country": ["US"],
            "genre_ids": [18, 9648],
            "original_language": "en",
            "vote_count": 133,
            "name": "Pretty Little Liars",
            "original_name": "Pretty Little Liars"
          },
        ],
      };
      expect(result, expectedJsonMap);
      expect(tVResponseModel.toJson(), isA<String>());
    });
  });
}
