import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/usecases/get_watchlist_tv.dart';

part 'tv_watchlist_state.dart';

class TvWatchlistCubit extends Cubit<TvWatchlistState> {
  final GetWatchlistTv getWatchlistTv;

  TvWatchlistCubit({
    required this.getWatchlistTv,
  }) : super(TvWatchlistInitial());

  Future<void> loadTvWatchlist() async {
    emit(TvWatchlistLoading());
    final result = await getWatchlistTv.execute();

    result.fold(
      (error) => emit(TvWatchlistFailure(message: error.message)),
      (tvList) => emit(
        TvWatchlistSuccess(tv: tvList),
      ),
    );
  }
}
