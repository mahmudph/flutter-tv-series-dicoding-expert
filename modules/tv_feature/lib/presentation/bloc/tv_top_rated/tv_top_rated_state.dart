part of 'tv_top_rated_cubit.dart';

abstract class TvTopRatedState extends Equatable {
  const TvTopRatedState();

  @override
  List<Object> get props => [];
}

class TvTopRatedInitial extends TvTopRatedState {}

/// top rated tv state
class TvTopRatedTvLoading extends TvTopRatedState {}

class TvTopRatedTvSuccess extends TvTopRatedState {
  final List<Tv> listTopRatedTv;

  const TvTopRatedTvSuccess({
    required this.listTopRatedTv,
  });
}

class TvTopRatedTvFailure extends TvTopRatedState {
  final String message;

  const TvTopRatedTvFailure({
    required this.message,
  });
}
