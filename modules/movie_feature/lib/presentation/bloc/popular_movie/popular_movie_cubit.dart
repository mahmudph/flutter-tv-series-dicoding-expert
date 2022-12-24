import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie.dart';
import 'package:movie_feature/domain/usecases/get_popular_movies.dart';

part 'popular_movie_state.dart';

class PopularMovieCubit extends Cubit<PopularMovieState> {
  final GetPopularMovies popularMovies;

  PopularMovieCubit({
    required this.popularMovies,
  }) : super(PopularMovieLoading());

  Future<void> fetchPopularMovies() async {
    final results = await popularMovies.execute();

    results.fold(
      (error) => emit(PopularMovieFailure(message: error.message)),
      (movies) => emit(PopularMovieSucess(movies: movies)),
    );
  }
}
