import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie.dart';
import 'package:movie_feature/domain/usecases/search_movies.dart';

part 'search_movie_state.dart';

class SearchMovieCubit extends Cubit<SearchMovieState> {
  final SearchMovies searchMovies;

  SearchMovieCubit({
    required this.searchMovies,
  }) : super(SearchMovieInitial());

  Future<void> searchMoviesByQuery(String query) async {
    emit(SearchMovieLoading());
    final results = await searchMovies.execute(query);

    results.fold(
      (error) => emit(SearchMovieFailure(message: error.message)),
      (movies) => emit(SearchMovieSuccess(movies: movies)),
    );
  }
}
