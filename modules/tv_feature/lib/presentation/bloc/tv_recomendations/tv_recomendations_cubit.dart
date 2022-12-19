import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/tv.dart';
import 'package:tv_feature/domain/usecases/get_tv_recommendations.dart';

part 'tv_recomendations_state.dart';

class TvRecomendationsCubit extends Cubit<TvRecomendationsState> {
  final GetTvRecommendations tvRecommendations;

  TvRecomendationsCubit({
    required this.tvRecommendations,
  }) : super(TvRecomendationsInitial());

  Future<void> loadTvRecommendations(int tvId) async {
    emit(TvRecommendationLoading());
    final results = await tvRecommendations.execute(tvId);

    results.fold(
      (error) => emit(TvRecommendationFailure(message: error.message)),
      (tv) => emit(TvRecommendationSuccess(listRecomendationsTv: tv)),
    );
  }
}
