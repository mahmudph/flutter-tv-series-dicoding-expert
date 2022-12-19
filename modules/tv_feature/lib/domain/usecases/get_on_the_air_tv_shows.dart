import 'package:dartz/dartz.dart';
import 'package:core/commons/failure.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';

class GetOnTheAirTVShows {
  final TvRepository repository;

  GetOnTheAirTVShows(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnTheAirTVShows();
  }
}
