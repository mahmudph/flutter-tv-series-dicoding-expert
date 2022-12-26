import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_feature/domain/entitas/episode.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';

class GetTvSessionEpisode {
  final TvRepository tvRepository;

  GetTvSessionEpisode({required this.tvRepository});

  Future<Either<Failure, Episode>> execute(
    int tvId,
    int tvSessionId,
    int tvSesionEpisodeId,
  ) async {
    return tvRepository.getEpisodeBySession(
      tvId,
      tvSessionId,
      tvSesionEpisodeId,
    );
  }
}
