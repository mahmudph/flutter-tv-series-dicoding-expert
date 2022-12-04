import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetOnTheAirTVShows {
  final TvRepository repository;

  GetOnTheAirTVShows(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getOnTheAirTVShows();
  }
}
