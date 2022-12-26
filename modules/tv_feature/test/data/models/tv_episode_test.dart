import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/tv_episode.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {
  test(
    'create EpisodeModel from json',
    () {
      final result = EpisodeModel.fromJson(
        readJson('dummy_data/tv_session_episode.json'),
      );

      expect(result.id, episodeModel.id);
      expect(result.name, episodeModel.name);
      expect(result.overview, episodeModel.overview);
      expect(result.productionCode, episodeModel.productionCode);

      expect(result.seasonNumber, episodeModel.seasonNumber);
      expect(result.stillPath, episodeModel.stillPath);
      expect(result.voteAverage, episodeModel.voteAverage);
      expect(result.voteCount, episodeModel.voteCount);
    },
  );

  test(
    'should transfrom from EpisodeModel to EpisodeEntity success',
    () {
      final result = EpisodeModel.fromJson(
        readJson('dummy_data/tv_session_episode.json'),
      );

      expect(result.toEntity(), episode);
    },
  );

  test(
    'should transfrom from EpisodeModel to map',
    () {
      final expectedMap = {
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
      };
      expect(episodeModel.toMap(), expectedMap);
    },
  );
}
