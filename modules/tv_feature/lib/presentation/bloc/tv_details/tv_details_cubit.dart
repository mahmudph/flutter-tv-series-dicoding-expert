import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';
import 'package:tv_feature/domain/usecases/get_tv_detail.dart';

part 'tv_details_state.dart';

class TvDetailsCubit extends Cubit<TvDetailsState> {
  final GetTvDetail getTvDetail;

  TvDetailsCubit({
    required this.getTvDetail,
  }) : super(TvDetailsInitial());

  Future<void> fetchTvDetail(int id) async {
    emit(TvDetailsLoading());
    final detailResult = await getTvDetail.execute(id);

    detailResult.fold(
      (failure) => emit(TvDetailsFailure(message: failure.message)),
      (tv) => emit(
        TvDetailsSuccess(
          tvDetail: tv,
        ),
      ),
    );
  }
}
