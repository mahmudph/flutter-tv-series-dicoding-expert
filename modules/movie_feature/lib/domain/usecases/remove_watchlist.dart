import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_feature/domain/entities/movie_detail.dart';
import 'package:movie_feature/domain/repositories/movie_repository.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
