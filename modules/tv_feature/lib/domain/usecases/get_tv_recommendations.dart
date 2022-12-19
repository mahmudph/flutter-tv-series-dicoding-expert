import 'package:dartz/dartz.dart';
import 'package:core/commons/failure.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';

class GetTvRecommendations {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
