part of 'tv_session_episode_cubit.dart';

abstract class TvSessionEpisodeState extends Equatable {
  const TvSessionEpisodeState();

  @override
  List<Object> get props => [];
}

class TvSessionEpisodeInitial extends TvSessionEpisodeState {}

class TvSessionEpisodeLoading extends TvSessionEpisodeState {}

class TvSessionEpisodeSuccess extends TvSessionEpisodeState {
  final Episode episode;
  const TvSessionEpisodeSuccess({required this.episode});

  @override
  List<Object> get props => [episode];
}

class TvSessionEpisodeFailure extends TvSessionEpisodeState {
  final String message;
  const TvSessionEpisodeFailure({required this.message});

  @override
  List<Object> get props => [message];
}
