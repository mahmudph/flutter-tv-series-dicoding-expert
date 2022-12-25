part of 'watchlist_movie_status_cubit.dart';

abstract class WatchlistMovieStatusState extends Equatable {
  const WatchlistMovieStatusState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieStatusInitial extends WatchlistMovieStatusState {}

class WatchlistMovieStatusData extends WatchlistMovieStatusState {
  final bool isAddToWatchlist;
  final String message;

  const WatchlistMovieStatusData({
    this.isAddToWatchlist = false,
    this.message = '',
  });

  @override
  List<Object> get props => [isAddToWatchlist, message];
}
