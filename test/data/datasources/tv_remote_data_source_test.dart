import 'dart:io';

import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_detail_response.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('Get On the air tv', () {
    final tvResult = TvResponse.fromJson(
      readJson('dummy_data/on_the_air_tv.json'),
    ).results;

    test('should return list of tv Model when the response code is 200',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'),
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

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getOnTheAirTVShows();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Tv', () {
    final resultTvList = TvResponse.fromJson(
      readJson('dummy_data/tv_popular.json'),
    ).results;

    test('should return list of tv when response is success (200)', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/popular?$API_KEY'),
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

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/popular?$API_KEY'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );
      // act
      final call = dataSource.getPopularTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated tv', () {
    final resultTvList = TvResponse.fromJson(
      readJson('dummy_data/tv_top_rated.json'),
    ).results;

    test('should return list of tv when response code is 200 ', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'),
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

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '$BASE_URL/tv/top_rated?$API_KEY',
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          'Not Found',
          404,
        ),
      );
      // act
      final call = dataSource.getTopRatedTvs();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv detail', () {
    final tId = 1;
    final resultTvDetail = TvDetailResponse.fromJson(
      readJson('dummy_data/tv_details.json'),
    );

    test('should return tv detail when the response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/$tId?$API_KEY'),
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

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/$tId?$API_KEY'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          'Not Found',
          404,
        ),
      );
      // act
      final call = dataSource.getTvDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv recommendations', () {
    final tvListRecommendations = TvResponse.fromJson(
      readJson('dummy_data/tv_recommendations.json'),
    ).results;
    final tId = 1;

    test('should return list of Tv Model when the response code is 200',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY'),
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

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '$BASE_URL/tv/$tId/recommendations?$API_KEY',
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );
      // act
      final call = dataSource.getTvRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tvs', () {
    final tvSearchResult = TvResponse.fromJson(
      readJson('dummy_data/tv_search.json'),
    ).results;

    final tQuery = 'Spiderman';

    test('should return list of tvs when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
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

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
        ),
      ).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );
      // act
      final call = dataSource.searchTvs(tQuery);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
