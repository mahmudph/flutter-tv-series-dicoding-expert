import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_feature/domain/entities/movie_detail.dart';
import 'package:movie_feature/domain/repositories/movie_repository.dart';

class GetMovieDetail {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
