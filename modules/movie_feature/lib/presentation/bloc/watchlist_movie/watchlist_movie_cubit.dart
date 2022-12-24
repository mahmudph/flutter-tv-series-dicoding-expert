import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie.dart';
import 'package:movie_feature/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieCubit({
    required this.getWatchlistMovies,
  }) : super(WatchlistMovieInitial());

  Future<void> loadMovieWatchlist() async {
    emit(WatchlistMovieLoading());

    final result = await getWatchlistMovies.execute();

    result.fold(
      (failure) => emit(WatchlistMovieFailure(message: failure.message)),
      (movies) => emit(
        WatchlistMovieDataSuccess(movies: movies),
      ),
    );
  }
}
