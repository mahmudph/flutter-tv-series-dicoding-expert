part of 'tv_populars_cubit.dart';

abstract class TvPopularsState extends Equatable {
  const TvPopularsState();

  @override
  List<Object> get props => [];
}

class TvPopularsInitial extends TvPopularsState {}

/// on populars tv state
class TvPopularTvLoading extends TvPopularsState {}

class TvPopularTvSuccess extends TvPopularsState {
  final List<Tv> listPopularTvTv;

  const TvPopularTvSuccess({
    required this.listPopularTvTv,
  });
}

class TvPopularTvFailure extends TvPopularsState {
  final String message;

  const TvPopularTvFailure({
    required this.message,
  });
}
