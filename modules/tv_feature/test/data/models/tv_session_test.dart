import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/tv_session_response.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  test('create tvSessionResponse from json', () {
    final jsonString = readJson('dummy_data/tv_session.json');
    final result = TvSessionResponse.fromJson(jsonString);

    expect(result.id, tvSessionResponse.id);
    expect(result.name, tvSessionResponse.name);
    expect(result.overview, tvSessionResponse.overview);
    expect(result.posterPath, tvSessionResponse.posterPath);
  });

  test('create entity from TvSessionResponse', () {
    expect(tvSessionResponse.toEntity(), tvSession);
  });

  test('create json map from TvSessionResponse', () {
    final expectedJsonMap = {
      "id": 1,
      "episodes": [
        {
          "id": 1,
          "episode_number": 1,
          "air_date": '2022-10-12',
          "name": 'name',
          "overview": 'overview',
          "production_code": 'productionCode',
          "season_number": 1,
          "vote_average": 1.0,
          "vote_count": 1,
          "still_path": "/wrGWeW4WKxnaeA8sxJb2T9O6ryo.jpg",
        }
      ],
      "air_date": '2022-10-12',
      "name": 'name',
      "overview": 'overview',
      "season_number": 12,
      "poster_path": "/zwaj4egrhnXOBIit1tyb4Sbt3KP.jpg",
    };

    expect(tvSessionResponse.toMap(), expectedJsonMap);
  });
}
