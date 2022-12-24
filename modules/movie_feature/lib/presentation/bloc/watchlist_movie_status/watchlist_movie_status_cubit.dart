import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie_detail.dart';
import 'package:movie_feature/domain/usecases/get_watchlist_status.dart';
import 'package:movie_feature/domain/usecases/remove_watchlist.dart';
import 'package:movie_feature/domain/usecases/save_watchlist.dart';

part 'watchlist_movie_status_state.dart';

class WatchlistMovieStatusCubit extends Cubit<WatchlistMovieStatusState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistMovieStatusCubit({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const WatchlistMovieStatusData());

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);

    result.fold(
      (failure) => emit(WatchlistMovieStatusData(message: failure.message)),
      (successMessage) => emit(
        WatchlistMovieStatusData(
          message: successMessage,
          isAddToWatchlist: true,
        ),
      ),
    );
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);

    result.fold(
      (failure) => emit(WatchlistMovieStatusData(
        message: failure.message,
        isAddToWatchlist: true,
      )),
      (successMessage) => emit(
        WatchlistMovieStatusData(
          message: successMessage,
          isAddToWatchlist: false,
        ),
      ),
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final isAddedToWatchlist = await getWatchListStatus.execute(id);
    emit(WatchlistMovieStatusData(isAddToWatchlist: isAddedToWatchlist));
  }
}
