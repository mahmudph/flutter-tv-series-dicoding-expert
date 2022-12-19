import 'package:dartz/dartz.dart';
import 'package:core/commons/failure.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';

class GetTvDetail {
  final TvRepository repository;

  GetTvDetail(this.repository);

  Future<Either<Failure, TvDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
