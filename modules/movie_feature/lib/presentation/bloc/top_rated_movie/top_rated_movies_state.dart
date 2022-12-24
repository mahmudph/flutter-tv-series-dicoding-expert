part of 'top_rated_movies_cubit.dart';

abstract class TopRatedMoviesState extends Equatable {
  const TopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class TopRatedMoviesInitial extends TopRatedMoviesState {}

class TopRatedMoviesLoading extends TopRatedMoviesState {}

class TopRatedMoviesSuccess extends TopRatedMoviesState {
  final List<Movie> movies;

  const TopRatedMoviesSuccess({required this.movies});

  @override
  List<Object> get props => [movies];
}

class TopRatedMoviesFailure extends TopRatedMoviesState {
  final String message;

  const TopRatedMoviesFailure({required this.message});

  @override
  List<Object> get props => [message];
}
