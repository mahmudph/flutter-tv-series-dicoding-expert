import 'dart:io';

import 'package:core/commons/exception.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/data/models/movie_model.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    test(
        'should return remote data when the call to remote data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getNowPlayingMovies())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.getNowPlayingMovies();
      // assert
      verify(() => mockRemoteDataSource.getNowPlayingMovies());
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getNowPlayingMovies()).thenThrow(
        ServerException(message: ''),
      );
      // act
      final result = await repository.getNowPlayingMovies();
      // assert
      verify(() => mockRemoteDataSource.getNowPlayingMovies());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getNowPlayingMovies();
      // assert
      verify(() => mockRemoteDataSource.getNowPlayingMovies());
      expect(
          result,
          equals(const Left(
              ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('Popular Movies', () {
    test(
      'should return movie list when call to data source is success',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getPopularMovies())
            .thenAnswer((_) async => tMovieModelList);
        // act
        final result = await repository.getPopularMovies();
        // assert
        /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
        final resultList = result.getOrElse(() => []);
        expect(resultList, tMovieList);
      },
    );

    test(
        'should return server failure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPopularMovies())
          .thenThrow(ServerException(message: ''));
      // act
      final result = await repository.getPopularMovies();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return connection failure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getPopularMovies())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularMovies();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTopRatedMovies())
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.getTopRatedMovies();
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(ServerException(message: ''));
      // act
      final result = await repository.getTopRatedMovies();
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedMovies();
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group(
    'Get Movie Detail',
    () {
      const tId = 1;

      test(
        'should return Movie data when the call to remote data source is successful',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getMovieDetail(tId)).thenAnswer(
            (_) async => tMovieResponse,
          );

          // act
          final result = await repository.getMovieDetail(tId);

          // assert
          verify(() => mockRemoteDataSource.getMovieDetail(tId));

          expect(result, equals(const Right(testMovieDetail)));
        },
      );

      test(
          'should return Server Failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getMovieDetail(tId))
            .thenThrow(ServerException(message: ''));
        // act
        final result = await repository.getMovieDetail(tId);
        // assert
        verify(() => mockRemoteDataSource.getMovieDetail(tId));
        expect(result, equals(const Left(ServerFailure(''))));
      });

      test(
        'should return connection failure when the device is not connected to internet',
        () async {
          // arrange
          when(() => mockRemoteDataSource.getMovieDetail(tId)).thenThrow(
            const SocketException('Failed to connect to the network'),
          );
          // act
          final result = await repository.getMovieDetail(tId);
          // assert
          verify(() => mockRemoteDataSource.getMovieDetail(tId));
          expect(
            result,
            equals(
              const Left(
                ConnectionFailure('Failed to connect to the network'),
              ),
            ),
          );
        },
      );
    },
  );

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    const tId = 1;

    test('should return data (movie list) when the call is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getMovieRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assert
      verify(() => mockRemoteDataSource.getMovieRecommendations(tId));
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(ServerException(message: ''));
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assertbuild runner
      verify(() => mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getMovieRecommendations(tId);
      // assert
      verify(() => mockRemoteDataSource.getMovieRecommendations(tId));
      expect(
        result,
        equals(
          const Left(
            ConnectionFailure('Failed to connect to the network'),
          ),
        ),
      );
    });
  });

  group('Seach Movies', () {
    const tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when call to data source is unsuccessful',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchMovies(tQuery)).thenThrow(
        ServerException(message: ''),
      );
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      expect(result, const Left(ServerFailure('')));
    });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
        () async {
      // arrange
      when(() => mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.searchMovies(tQuery);
      // assert
      expect(result,
          const Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(() => mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testMovieDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testMovieDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(() => mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testMovieDetail);
      // assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(() => mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testMovieDetail);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tId = 1;
      when(() => mockLocalDataSource.getMovieById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(() => mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await repository.getWatchlistMovies();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });
}
