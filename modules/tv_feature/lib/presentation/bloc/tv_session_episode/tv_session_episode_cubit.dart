import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/episode.dart';
import 'package:tv_feature/domain/usecases/get_tv_session_episode.dart';

part 'tv_session_episode_state.dart';

class TvSessionEpisodeCubit extends Cubit<TvSessionEpisodeState> {
  final GetTvSessionEpisode getTvSessionEpisode;

  TvSessionEpisodeCubit({
    required this.getTvSessionEpisode,
  }) : super(TvSessionEpisodeInitial());

  Future<void> loadTvSessionEpisode(
    int tvId,
    int tvSessionId,
    int tvEpisodeId,
  ) async {
    /// emit loading state
    emit(TvSessionEpisodeLoading());

    final result = await getTvSessionEpisode.execute(
      tvId,
      tvSessionId,
      tvEpisodeId,
    );

    result.fold(
      (failure) => emit(TvSessionEpisodeFailure(message: failure.message)),
      (episode) => emit(TvSessionEpisodeSuccess(episode: episode)),
    );
  }
}
