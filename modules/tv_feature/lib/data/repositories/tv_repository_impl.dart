import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:core/commons/failure.dart';
import 'package:core/commons/exception.dart';
import 'package:tv_feature/data/models/tv_table.dart';
import 'package:tv_feature/domain/entitas/episode.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';
import 'package:tv_feature/domain/entitas/tv_session.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';
import 'package:tv_feature/data/datasources/tv_local_data_source.dart';
import 'package:tv_feature/data/datasources/tv_remote_data_source.dart';

class TvRepositoryImpl implements TvRepository {
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;

  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final String noInternetConnection = "Failed to connect to the network";

  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTVShows() async {
    try {
      final result = await remoteDataSource.getOnTheAirTVShows();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTvs() async {
    try {
      final result = await remoteDataSource.getPopularTvs();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTvs() async {
    try {
      final result = await remoteDataSource.getTopRatedTvs();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvDetail(id);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTvRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTvs() async {
    try {
      final result = await localDataSource.getWatchlistTvs();
      return Right(result.map((model) => model.toEntity()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    try {
      final result = await localDataSource.getTvById(id);
      return result != null;
    } on DatabaseException catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource.removeWatchlistTv(
        TvTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource.insertWatchlistTv(
        TvTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvs(String query) async {
    try {
      final result = await remoteDataSource.searchTvs(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, Episode>> getEpisodeBySession(
    int tvId,
    int tvSessionId,
    int tvEpisodeId,
  ) async {
    try {
      /// get the episode for the spesific sessions
      final result = await remoteDataSource.getSessionEpisode(
        tvId,
        tvSessionId,
        tvEpisodeId,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, TvSession>> getTvSession(
    int tvId,
    int tvSessionId,
  ) async {
    try {
      final result = await remoteDataSource.getTvSession(tvId, tvSessionId);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TlsException catch (e) {
      return Left(SSLFailure(e.message));
    } on SocketException {
      return Left(ConnectionFailure(noInternetConnection));
    }
  }
}
