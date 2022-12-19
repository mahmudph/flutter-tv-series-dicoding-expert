import 'package:dartz/dartz.dart';
import 'package:core/commons/failure.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';

class RemoveWatchlistTv {
  final TvRepository repository;

  RemoveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeWatchlist(tv);
  }
}
