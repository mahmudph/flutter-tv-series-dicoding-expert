import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie.dart';
import 'package:movie_feature/domain/usecases/get_top_rated_movies.dart';

part 'top_rated_movies_state.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;
  TopRatedMoviesCubit({
    required this.getTopRatedMovies,
  }) : super(TopRatedMoviesInitial());

  Future<void> fetchTopRatedMovies() async {
    emit(TopRatedMoviesLoading());

    final results = await getTopRatedMovies.execute();

    results.fold(
      (error) => emit(TopRatedMoviesFailure(message: error.message)),
      (movies) => emit(TopRatedMoviesSuccess(movies: movies)),
    );
  }
}
