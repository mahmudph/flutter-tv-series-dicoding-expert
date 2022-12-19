part of 'tv_on_the_air_cubit.dart';

abstract class TvOnTheAirState extends Equatable {
  const TvOnTheAirState();

  @override
  List<Object> get props => [];
}

class TvOnTheAirInitial extends TvOnTheAirState {}

class TvOnTheAirLoading extends TvOnTheAirState {}

class TvOnTheAirSuccess extends TvOnTheAirState {
  final List<Tv> listOnTheAirTv;

  const TvOnTheAirSuccess({
    required this.listOnTheAirTv,
  });
}

class TvOnTheAirFailure extends TvOnTheAirState {
  final String message;

  const TvOnTheAirFailure({
    required this.message,
  });
}
