import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:movie_feature/domain/entities/movie.dart';
import 'package:movie_feature/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
