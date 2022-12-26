import 'package:dartz/dartz.dart';
import 'package:core/commons/failure.dart';
import 'package:tv_feature/domain/entitas/episode.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/entitas/tv_session.dart';

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

  Future<Either<Failure, TvSession>> getTvSession(int tvId, int tvSessionId);
  Future<Either<Failure, Episode>> getEpisodeBySession(
    int tvId,
    int tvSessionId,
    int tvEpisodeId,
  );
}
