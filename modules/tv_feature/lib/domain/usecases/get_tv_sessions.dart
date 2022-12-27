import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_feature/domain/entitas/tv_session.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';

class GetTvSession {
  final TvRepository tvRepository;

  GetTvSession(this.tvRepository);

  Future<Either<Failure, TvSession>> execute(int tvId, tvSessionId) async {
    return tvRepository.getTvSession(tvId, tvSessionId);
  }
}
