import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/usecases/search_tv.dart';

part 'tv_search_state.dart';

class TvSearchCubit extends Cubit<TvSearchState> {
  final SearchTv searchTv;

  TvSearchCubit({
    required this.searchTv,
  }) : super(TvSearchInitial());

  Future<void> searchTvByQuery(query) async {
    emit(TvSearchLoading());
    final result = await searchTv.execute(query);

    result.fold(
      (errors) => emit(TvSearchFailure(message: errors.message)),
      (tv) => emit(TvSearchSuccess(tv: tv)),
    );
  }
}
