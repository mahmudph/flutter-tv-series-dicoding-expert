part of 'now_playing_movie_cubit.dart';

abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieInitial extends NowPlayingMovieState {}

class NowPlayingMovieLoading extends NowPlayingMovieState {}

class NowPlayingMovieSucess extends NowPlayingMovieState {
  final List<Movie> movies;

  const NowPlayingMovieSucess({required this.movies});

  @override
  List<Object> get props => [movies];
}

class NowPlayingMovieFailure extends NowPlayingMovieState {
  final String message;

  const NowPlayingMovieFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
