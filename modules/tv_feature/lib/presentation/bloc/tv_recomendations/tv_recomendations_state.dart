part of 'tv_recomendations_cubit.dart';

abstract class TvRecomendationsState extends Equatable {
  const TvRecomendationsState();

  @override
  List<Object> get props => [];
}

class TvRecomendationsInitial extends TvRecomendationsState {}

class TvRecommendationLoading extends TvRecomendationsState {}

class TvRecommendationSuccess extends TvRecomendationsState {
  final List<Tv> listRecomendationsTv;

  const TvRecommendationSuccess({
    required this.listRecomendationsTv,
  });
}

class TvRecommendationFailure extends TvRecomendationsState {
  final String message;

  const TvRecommendationFailure({
    required this.message,
  });
}
