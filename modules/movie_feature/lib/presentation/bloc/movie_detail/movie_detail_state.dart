part of 'movie_detail_cubit.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailSuccess extends MovieDetailState {
  final MovieDetail movieDetail;

  const MovieDetailSuccess({
    required this.movieDetail,
  });

  @override
  List<Object> get props => [movieDetail];
}

class MovieDetailFailure extends MovieDetailState {
  final String message;

  const MovieDetailFailure({required this.message});

  @override
  List<Object> get props => [message];
}
