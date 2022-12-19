import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/usecases/get_on_the_air_tv_shows.dart';

part 'tv_on_the_air_state.dart';

class TvOnTheAirCubit extends Cubit<TvOnTheAirState> {
  final GetOnTheAirTVShows getOnTheAirTvShow;

  TvOnTheAirCubit({
    required this.getOnTheAirTvShow,
  }) : super(TvOnTheAirInitial());

  Future<void> fetchOnTheAirTvs() async {
    emit(TvOnTheAirLoading());
    final result = await getOnTheAirTvShow.execute();

    result.fold(
      (failure) => emit(TvOnTheAirFailure(message: failure.message)),
      (tvs) => emit(TvOnTheAirSuccess(listOnTheAirTv: tvs)),
    );
  }
}
