part of 'tv_watchlist_status_cubit.dart';

abstract class TvWatchlistStatusState extends Equatable {
  const TvWatchlistStatusState();

  @override
  List<Object> get props => [];
}

class TvWatchlistStatusData extends TvWatchlistStatusState {
  final bool isAddedWatchlist;
  final String message;

  const TvWatchlistStatusData({
    this.isAddedWatchlist = false,
    this.message = '',
  });

  @override
  List<Object> get props => [
        isAddedWatchlist,
        message,
      ];
}
