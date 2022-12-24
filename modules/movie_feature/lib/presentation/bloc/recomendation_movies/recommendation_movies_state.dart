part of 'recommendation_movies_cubit.dart';

abstract class RecommendationMoviesState extends Equatable {
  const RecommendationMoviesState();

  @override
  List<Object> get props => [];
}

class RecommendationMoviesInitial extends RecommendationMoviesState {}

class RecommendationMoviesLoading extends RecommendationMoviesState {}

class RecommendationMoviesFailure extends RecommendationMoviesState {
  final String message;

  const RecommendationMoviesFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class RecommendationMoviesSuccess extends RecommendationMoviesState {
  final List<Movie> movies;
  const RecommendationMoviesSuccess({
    required this.movies,
  });

  @override
  List<Object> get props => [movies];
}
