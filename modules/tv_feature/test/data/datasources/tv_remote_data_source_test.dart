import 'dart:io';

import 'package:core/commons/exception.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/datasources/tv_remote_data_source.dart';
import 'package:tv_feature/data/models/tv_detail_response.dart';
import 'package:tv_feature/data/models/tv_episode.dart';
import 'package:tv_feature/data/models/tv_response.dart';
import 'package:tv_feature/data/models/tv_session_response.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';
import '../../mocks/data_mock.dart';

void main() {
  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  const url = '';

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(
      client: mockHttpClient,
      baseUrl: url,
    );
  });

  group('Get On the air tv', () {
    final tvResult = TvResponse.fromJson(
      readJson('dummy_data/on_the_air_tv.json'),
    ).results;

    test('should return list of tv Model when the response code is 200',
        () async {
      // arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('$url/tv/on_the_air'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/on_the_air_tv.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getOnTheAirTVShows();
      // assert
      expect(result, equals(tvResult));
    });
  });

  group('get Popular Tv', () {
    final resultTvList = TvResponse.fromJson(
      readJson('dummy_data/tv_popular.json'),
    ).results;

    test('should return list of tv when response is success (200)', () async {
      // arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('$url/tv/popular'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_popular.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getPopularTvs();
      // assert
      expect(result, resultTvList);
    });
  });

  group('get Top Rated tv', () {
    final resultTvList = TvResponse.fromJson(
      readJson('dummy_data/tv_top_rated.json'),
    ).results;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('$url/tv/top_rated'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_top_rated.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getTopRatedTvs();
      // assert
      expect(result, resultTvList);
    });
  });

  group('get tv detail', () {
    const tId = 1;
    final resultTvDetail = TvDetailResponse.fromJson(
      readJson('dummy_data/tv_details.json'),
    );

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('$url/tv/$tId'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_details.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getTvDetail(tId);
      // assert
      expect(result, equals(resultTvDetail));
    });
  });

  group('get tv recommendations', () {
    final tvListRecommendations = TvResponse.fromJson(
      readJson('dummy_data/tv_recommendations.json'),
    ).results;
    const tId = 1;

    test('should return list of Tv Model when the response code is 200',
        () async {
      // arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('$url/tv/$tId/recommendations'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_recommendations.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getTvRecommendations(tId);
      // assert
      expect(result, equals(tvListRecommendations));
    });
  });

  group('search tvs', () {
    final tvSearchResult = TvResponse.fromJson(
      readJson('dummy_data/tv_search.json'),
    ).results;

    const tQuery = 'Spiderman';

    test('should return list of tvs when response code is 200', () async {
      // arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('$url/search/tv?query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_search.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.searchTvs(tQuery);
      // assert
      expect(result, tvSearchResult);
    });
  });

  group(
    'get tv session',
    () {
      const tvId = 1;
      const tvSessionId = 2;

      test(
        'should get tv sesssion data with success',
        () async {
          /// stub
          when(
            () => mockHttpClient.get(
              Uri.parse('$url/tv/$tvId/season/$tvSessionId'),
            ),
          ).thenAnswer(
            (_) async => http.Response(
              readJson('dummy_data/tv_session.json'),
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ),
          );

          // act
          final result = await dataSource.getTvSession(tvId, tvSessionId);

          expect(result, isA<TvSessionResponse>());
          expect(result.id, tvSessionResponse.id);
          expect(result.name, tvSessionResponse.name);
          expect(result.overview, tvSessionResponse.overview);
          expect(result.airDate, tvSessionResponse.airDate);
        },
      );

      test(
        'should get tv sesssion data with failure',
        () async {
          /// stub
          when(
            () => mockHttpClient.get(
              Uri.parse('$url/tv/$tvId/season/$tvSessionId'),
            ),
          ).thenThrow(
            ServerException(message: 'unauthorized request'),
          );

          // act
          final result = dataSource.getTvSession(tvId, tvSessionId);

          expect(result, throwsA(isA<ServerException>()));
        },
      );
    },
  );

  group(
    'get tv session episode',
    () {
      const tvId = 1;
      const tvSessionId = 2;
      const tvSessionEpisodeId = 3;

      test(
        'should get tv sesssion data with success',
        () async {
          /// build url request
          final urlRequest = Uri.parse(
            '$url/tv/$tvId/season/$tvSessionId/episode/$tvSessionEpisodeId',
          );

          /// stub
          when(() => mockHttpClient.get(urlRequest)).thenAnswer(
            (_) async => http.Response(
              readJson('dummy_data/tv_session_episode.json'),
              200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              },
            ),
          );

          // act
          final result = await dataSource.getSessionEpisode(
            tvId,
            tvSessionId,
            tvSessionEpisodeId,
          );

          verify(() => mockHttpClient.get(urlRequest)).called(1);

          expect(result, isA<EpisodeModel>());
          expect(result.id, episodeModel.id);
          expect(result.name, episodeModel.name);
          expect(result.overview, episodeModel.overview);
          expect(result.airDate, episodeModel.airDate);
        },
      );

      test(
        'should get tv sesssion data with failure',
        () async {
          // build url request
          final urlRequest = Uri.parse(
            '$url/tv/$tvId/season/$tvSessionId/episode/$tvSessionEpisodeId',
          );

          /// stub
          when(
            () => mockHttpClient.get(urlRequest),
          ).thenThrow(
            ServerException(message: 'unauthorized request'),
          );

          // act
          final result = dataSource.getSessionEpisode(
            tvId,
            tvSessionId,
            tvSessionEpisodeId,
          );

          verify(() => mockHttpClient.get(urlRequest)).called(1);

          expect(result, throwsA(isA<ServerException>()));
        },
      );
    },
  );
}
