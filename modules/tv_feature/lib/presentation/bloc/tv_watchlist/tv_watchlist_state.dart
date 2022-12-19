part of 'tv_watchlist_cubit.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistInitial extends TvWatchlistState {}

class TvWatchlistLoading extends TvWatchlistState {}

class TvWatchlistSuccess extends TvWatchlistState {
  final List<Tv> tv;

  const TvWatchlistSuccess({
    required this.tv,
  });
}

class TvWatchlistFailure extends TvWatchlistState {
  final String message;

  const TvWatchlistFailure({
    required this.message,
  });
}
