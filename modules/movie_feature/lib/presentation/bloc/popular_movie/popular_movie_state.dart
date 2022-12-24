part of 'popular_movie_cubit.dart';

abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMovieLoading extends PopularMovieState {}

class PopularMovieSucess extends PopularMovieState {
  final List<Movie> movies;

  const PopularMovieSucess({required this.movies});

  @override
  List<Object> get props => [movies];
}

class PopularMovieFailure extends PopularMovieState {
  final String message;

  const PopularMovieFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
