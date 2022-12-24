import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie.dart';
import 'package:movie_feature/domain/usecases/get_movie_recommendations.dart';

part 'recommendation_movies_state.dart';

class RecommendationMoviesCubit extends Cubit<RecommendationMoviesState> {
  final GetMovieRecommendations getMovieRecommendations;

  RecommendationMoviesCubit({
    required this.getMovieRecommendations,
  }) : super(RecommendationMoviesInitial());

  Future<void> fetchRecommendationMovies(int movieId) async {
    emit(RecommendationMoviesLoading());
    final results = await getMovieRecommendations.execute(movieId);

    results.fold(
      (error) => emit(RecommendationMoviesFailure(message: error.message)),
      (movies) => emit(RecommendationMoviesSuccess(movies: movies)),
    );
  }
}
