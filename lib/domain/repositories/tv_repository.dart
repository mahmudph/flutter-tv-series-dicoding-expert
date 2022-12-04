import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/TvDetail.dart';
import 'package:ditonton/domain/entities/tv.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnTheAirTVShows();
  Future<Either<Failure, List<Tv>>> getPopularTvs();
  Future<Either<Failure, List<Tv>>> getTopRatedTvs();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTvs(String query);
  Future<Either<Failure, String>> saveWatchlist(TvDetail movie);
  Future<Either<Failure, String>> removeWatchlist(TvDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvs();
}
