import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie.dart';
import 'package:movie_feature/domain/usecases/get_now_playing_movies.dart';

part 'now_playing_movie_state.dart';

class NowPlayingMovieCubit extends Cubit<NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieCubit({
    required this.getNowPlayingMovies,
  }) : super(NowPlayingMovieInitial());

  Future<void> fetchNowPlayingMovie() async {
    emit(NowPlayingMovieLoading());
    final results = await getNowPlayingMovies.execute();

    results.fold(
      (error) => emit(NowPlayingMovieFailure(message: error.message)),
      (movies) => emit(NowPlayingMovieSucess(movies: movies)),
    );
  }
}
