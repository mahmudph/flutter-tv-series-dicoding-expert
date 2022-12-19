import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';
import 'package:tv_feature/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv_feature/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv_feature/domain/usecases/save_watchlist_tv.dart';

part 'tv_watchlist_status_state.dart';

class TvWatchlistStatusCubit extends Cubit<TvWatchlistStatusState> {
  final GetWatchListTvStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvWatchlistStatusCubit({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvWatchlistStatusData());

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist.execute(tv);

    result.fold(
      (failure) => emit(TvWatchlistStatusData(message: failure.message)),
      (successMessage) => emit(
        TvWatchlistStatusData(
          message: successMessage,
          isAddedWatchlist: true,
        ),
      ),
    );
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist.execute(tv);

    result.fold(
      (failure) => emit(
        TvWatchlistStatusData(message: failure.message, isAddedWatchlist: true),
      ),
      (successMessage) => emit(
        TvWatchlistStatusData(
          message: successMessage,
          isAddedWatchlist: false,
        ),
      ),
    );
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(TvWatchlistStatusData(isAddedWatchlist: result));
  }
}
