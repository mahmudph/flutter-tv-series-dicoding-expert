part of 'watchlist_movie_cubit.dart';

abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieInitial extends WatchlistMovieState {}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieDataSuccess extends WatchlistMovieState {
  final List<Movie> movies;
  const WatchlistMovieDataSuccess({required this.movies});

  @override
  List<Object> get props => [movies];
}

class WatchlistMovieFailure extends WatchlistMovieState {
  final String message;

  const WatchlistMovieFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
