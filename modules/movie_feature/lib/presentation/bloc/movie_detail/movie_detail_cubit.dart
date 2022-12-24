import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_feature/domain/entities/movie_detail.dart';
import 'package:movie_feature/domain/usecases/get_movie_detail.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail movieDetail;

  MovieDetailCubit({
    required this.movieDetail,
  }) : super(MovieDetailInitial());

  Future<void> loadMovieDetail(int movieId) async {
    emit(MovieDetailLoading());
    final results = await movieDetail.execute(movieId);

    results.fold(
      (error) => emit(MovieDetailFailure(message: error.message)),
      (movieDetail) => emit(MovieDetailSuccess(movieDetail: movieDetail)),
    );
  }
}
