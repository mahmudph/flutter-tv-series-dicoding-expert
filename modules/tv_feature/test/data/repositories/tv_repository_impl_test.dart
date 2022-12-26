import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/data/models/genre_model.dart';
import 'package:tv_feature/data/models/last_to_air_model.dart';
import 'package:tv_feature/data/models/session_model.dart';
import 'package:tv_feature/data/models/tv_detail_response.dart';
import 'package:tv_feature/data/models/tv_model.dart';
import 'package:tv_feature/data/repositories/tv_repository_impl.dart';
import 'package:tv_feature/domain/entitas/tv.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tvModel = TvModel(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
    firstAirDate: "2022-08-19",
    name: 'joko',
    originCountry: ['usa'],
    originalLanguage: 'en',
    originalName: 'joko',
  );

  const tv = Tv(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
    firstAirDate: "2022-08-19",
    name: 'joko',
    originCountry: ['usa'],
    originalLanguage: 'en',
    originalName: 'joko',
  );

  final tVModelList = <TvModel>[tvModel];
  final tVList = <Tv>[tv];

  group('On the air tv show', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getOnTheAirTVShows())
            .thenAnswer((_) async => tVModelList);
        // act
        final result = await repository.getOnTheAirTVShows();
        // assert
        verify(() => mockRemoteDataSource.getOnTheAirTVShows());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tVList);
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getOnTheAirTVShows()).thenThrow(
            ServerException(message: 'No internet connection available'));
        // act
        final result = await repository.getOnTheAirTVShows();
        // assert
        verify(() => mockRemoteDataSource.getOnTheAirTVShows());

        expect(
          result,
          equals(
            const Left(
              ServerFailure('No internet connection available'),
            ),
          ),
        );
      },
    );

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getOnTheAirTVShows()).thenThrow(
        const SocketException('Failed to connect to the network'),
      );
      // act
      final result = await repository.getOnTheAirTVShows();
      // assert
      verify(() => mockRemoteDataSource.getOnTheAirTVShows());
      expect(
        result,
        equals(const Left(
          ConnectionFailure('Failed to connect to the network'),
        )),
      );
    });
  });

  group('Popular Tvs', () {
    test('should return tv list when call to data source is success', () async {
      // arrange
      when(() => mockRemoteDataSource.getPopularTvs())
          .thenAnswer((_) async => tVModelList);
      // act
      final result = await repository.getPopularTvs();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tVList);
    });

    test(
      'should return server failure when call to data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularTvs()).thenThrow(
          ServerException(),
        );

        // act
        final result = await repository.getPopularTvs();

        // assert
        verify(() => mockRemoteDataSource.getPopularTvs()).called(1);

        expect(
          result,
          const Left(
            ServerFailure('No internet connection available'),
          ),
        );
      },
    );

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPopularTvs()).thenThrow(
        const SocketException('Failed to connect to the network'),
      );
      // act
      final result = await repository.getPopularTvs();
      // assert
      expect(
        result,
        const Left(
          ConnectionFailure('Failed to connect to the network'),
        ),
      );
    });
  });

  group('Top Rated tv', () {
    test(
      'should return tv list when call to data source is successful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedTvs())
            .thenAnswer((_) async => tVModelList);
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        final resultList = result.getOrElse(() => []);
        expect(resultList, tVList);
      },
    );

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTopRatedTvs()).thenThrow(
        ServerException(),
      );
      // act
      final result = await repository.getTopRatedTvs();
      // assert
      expect(
        result,
        const Left(
          ServerFailure('No internet connection available'),
        ),
      );
    });

    test(
      'should return ConnectionFailure when device is not connected to the internet',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTopRatedTvs()).thenThrow(
          const SocketException('Failed to connect to the network'),
        );
        // act
        final result = await repository.getTopRatedTvs();
        // assert
        expect(
          result,
          const Left(
            ConnectionFailure('Failed to connect to the network'),
          ),
        );
      },
    );
  });

  group('Get tv Detail', () {
    const tId = 1;
    final tvDetailRes = TvDetailResponse(
      backdropPath: 'backdropPath',
      episodeRunTime: const [2],
      firstAirDate: DateTime.now(),
      genres: const [GenreModel(id: 1, name: 'name')],
      homepage: 'homepage',
      id: 1,
      inProduction: false,
      languages: const ['us'],
      lastAirDate: DateTime.now(),
      lastEpisodeToAir: LastEpisodeToAirModel(
        airDate: DateTime.now(),
        episodeNumber: 2,
        id: 2,
        name: 'name',
        overview: 'overview',
        productionCode: '12',
        seasonNumber: 1,
        stillPath: 'stillPath',
        voteAverage: 2.2,
        voteCount: 11,
      ),
      name: 'name',
      nextEpisodeToAir: 'nextEpisodeToAir',
      numberOfEpisodes: 1,
      numberOfSeasons: 2,
      originCountry: const ['originCountry'],
      originalLanguage: 'originalLanguage',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 2.2,
      posterPath: 'posterPath',
      seasons: const [
        SeasonModel(
          airDate: "2022-08-10",
          episodeCount: 1,
          id: 2,
          name: 'name',
          overview: 'overview',
          posterPath: 'posterPath',
          seasonNumber: 2,
        )
      ],
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      voteAverage: 2.1,
      voteCount: 22,
    );

    test(
        'should return tv data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tvDetailRes);
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(() => mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(Right(tvDetailRes.toEntity())));
    });

    test(
      'should return Server Failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getTvDetail(tId)).thenThrow(
          ServerException(),
        );

        // act
        final result = await repository.getTvDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getTvDetail(tId));
        expect(
          result,
          equals(
            const Left(
              ServerFailure('No internet connection available'),
            ),
          ),
        );
      },
    );

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvDetail(tId);
      // assert
      verify(() => mockRemoteDataSource.getTvDetail(tId));
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group(
    'Get Tv Recommendations',
    () {
      const tId = 1;

      test(
        'should return data (tv list) when the call is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTvRecommendations(tId))
              .thenAnswer((_) async => tVModelList);
          // act
          final result = await repository.getTvRecommendations(tId);
          // assert
          verify(() => mockRemoteDataSource.getTvRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tVList));
        },
      );

      test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTvRecommendations(tId)).thenThrow(
            ServerException(message: 'No internet connection available'),
          );

          // act
          final result = await repository.getTvRecommendations(tId);

          // assertbuild runner
          verify(() => mockRemoteDataSource.getTvRecommendations(tId));
          expect(
            result,
            equals(
              const Left(ServerFailure('No internet connection available')),
            ),
          );
        },
      );

      test(
        'should return connection failure when the device is not connected to the internet',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getTvRecommendations(tId)).thenThrow(
              const SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvRecommendations(tId);
          // assert
          verify(() => mockRemoteDataSource.getTvRecommendations(tId));
          expect(
              result,
              equals(const Left(
                  ConnectionFailure('Failed to connect to the network'))));
        },
      );
    },
  );

  group('Seach Tvs', () {
    const tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchTvs(tQuery))
          .thenAnswer((_) async => tVModelList);
      // act
      final result = await repository.searchTvs(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tVList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchTvs(tQuery))
          .thenThrow(ServerException());
      // act
      final result = await repository.searchTvs(tQuery);
      // assert
      expect(
        result,
        const Left(
          ServerFailure('No internet connection available'),
        ),
      );
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchTvs(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchTvs(tQuery);
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist tv', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(() => mockLocalDataSource.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.insertWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(() => mockLocalDataSource.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.removeWatchlistTv(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(() => mockLocalDataSource.getTvById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });

    test('should return false when failed to check is added to wachlist',
        () async {
      // arrange
      const tId = 1;
      when(() => mockLocalDataSource.getTvById(tId)).thenThrow(
        DatabaseException(''),
      );
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist tv', () {
    test('should return list of tv', () async {
      // arrange
      when(() => mockLocalDataSource.getWatchlistTvs())
          .thenAnswer((_) async => [testTvTable]);
      // act
      final result = await repository.getWatchlistTvs();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testTvTable.toEntity()]);
    });

    test(
      'should throw DatabaseException when get getWatchlistTvs',
      () async {
        // arrange
        when(() => mockLocalDataSource.getWatchlistTvs()).thenThrow(
          DatabaseException(''),
        );
        // act
        final result = await repository.getWatchlistTvs();
        verify(() => mockLocalDataSource.getWatchlistTvs()).called(1);
        expect(result, const Left(DatabaseFailure('')));
      },
    );
  });

  group('get tv sessions', () {
    const tvId = 10;
    const tvSessionId = 1;

    test(
      'should throw DatabaseException when get',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getTvSession(tvId, tvSessionId),
        ).thenThrow(ServerException());

        // act
        final result = await repository.getTvSession(tvId, tvSessionId);

        verify(
          () => mockRemoteDataSource.getTvSession(tvId, tvSessionId),
        ).called(1);

        expect(
          result,
          const Left(
            ServerFailure('No internet connection available'),
          ),
        );
      },
    );

    test(
      'should get tv sessions with success',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getTvSession(tvId, tvSessionId),
        ).thenAnswer((_) async => tvSessionResponse);

        // act
        final result = await repository.getTvSession(tvId, tvSessionId);

        verify(
          () => mockRemoteDataSource.getTvSession(tvId, tvSessionId),
        ).called(1);

        expect(result, const Right(tvSession));
      },
    );
  });

  group(
    'get tv session episode',
    () {
      const tvId = 10;
      const tvSessionId = 1;
      const tvSessionEpisodeId = 2;

      test(
        'should get tv sessions episode with success',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getSessionEpisode(
              tvId,
              tvSessionId,
              tvSessionEpisodeId,
            ),
          ).thenAnswer((_) async => episodeModel);

          // act
          final result = await repository.getEpisodeBySession(
            tvId,
            tvSessionId,
            tvSessionEpisodeId,
          );

          verify(
            () => mockRemoteDataSource.getSessionEpisode(
              tvId,
              tvSessionId,
              tvSessionEpisodeId,
            ),
          ).called(1);

          expect(result, const Right(episode));
        },
      );

      test(
        'should get tv sessions episode with failure and throw ServerException',
        () async {
          // arrange
          when(
            () => mockRemoteDataSource.getSessionEpisode(
              tvId,
              tvSessionId,
              tvSessionEpisodeId,
            ),
          ).thenThrow(ServerException());

          // act
          final result = await repository.getEpisodeBySession(
            tvId,
            tvSessionId,
            tvSessionEpisodeId,
          );

          verify(
            () => mockRemoteDataSource.getSessionEpisode(
              tvId,
              tvSessionId,
              tvSessionEpisodeId,
            ),
          ).called(1);

          expect(
            result,
            const Left(
              ServerFailure('No internet connection available'),
            ),
          );
        },
      );
    },
  );
}
