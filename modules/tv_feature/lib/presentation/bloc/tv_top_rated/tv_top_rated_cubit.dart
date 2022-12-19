import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/usecases/get_top_rated_tv.dart';

part 'tv_top_rated_state.dart';

class TvTopRatedCubit extends Cubit<TvTopRatedState> {
  final GetTopRatedTv getTopRatedTv;

  TvTopRatedCubit({
    required this.getTopRatedTv,
  }) : super(TvTopRatedInitial());

  Future<void> fetchTopRatedTv() async {
    emit(TvTopRatedTvLoading());

    final result = await getTopRatedTv.execute();

    result.fold(
      (failure) => emit(TvTopRatedTvFailure(message: failure.message)),
      (tvData) => emit(TvTopRatedTvSuccess(listTopRatedTv: tvData)),
    );
  }
}
