part of 'tv_search_cubit.dart';

abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object> get props => [];
}

class TvSearchInitial extends TvSearchState {}
class TvSearchLoading extends TvSearchState {}

class TvSearchSuccess extends TvSearchState {
  final List<Tv> tv;

  const TvSearchSuccess({
    required this.tv,
  });

  @override
  List<Object> get props => [tv];
}

class TvSearchFailure extends TvSearchState {
  final String message;

  const TvSearchFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
