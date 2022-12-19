import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/usecases/get_popular_tv.dart';

part 'tv_populars_state.dart';

class TvPopularsCubit extends Cubit<TvPopularsState> {
  final GetPopularTv getPopularTv;

  TvPopularsCubit({
    required this.getPopularTv,
  }) : super(TvPopularsInitial());

  Future<void> fetchPopulartv() async {
    emit(TvPopularTvLoading());
    final result = await getPopularTv.execute();

    result.fold(
      (failure) => emit(TvPopularTvFailure(message: failure.message)),
      (tvData) => emit(TvPopularTvSuccess(listPopularTvTv: tvData)),
    );
  }
}
