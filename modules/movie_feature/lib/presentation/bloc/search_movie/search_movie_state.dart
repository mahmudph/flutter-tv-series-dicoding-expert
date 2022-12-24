part of 'search_movie_cubit.dart';

abstract class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

class SearchMovieInitial extends SearchMovieState {}
class SearchMovieLoading extends SearchMovieState {}

class SearchMovieSuccess extends SearchMovieState {
  final List<Movie> movies;
  const SearchMovieSuccess({required this.movies});

  @override
  List<Object> get props => [];
}

class SearchMovieFailure extends SearchMovieState {
  final String message;
  const SearchMovieFailure({required this.message});

  @override
  List<Object> get props => [message];
}
