import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_tv_session_episode.dart';
import 'package:tv_feature/presentation/bloc/tv_session_episode/tv_session_episode_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTvSessionEpissode extends Mock implements GetTvSessionEpisode {}

void main() {
  late TvSessionEpisodeCubit tvSessionEpisodeCubit;
  late MockGetTvSessionEpissode mockGetTvSessionEpissode;

  setUp(() {
    mockGetTvSessionEpissode = MockGetTvSessionEpissode();
    tvSessionEpisodeCubit = TvSessionEpisodeCubit(
      getTvSessionEpisode: mockGetTvSessionEpissode,
    );
  });

  const tvId = 1;
  const tvSessionId = 2;
  const tvEpisodeId = 4;

  blocTest(
    'should success to getget tv episode ',
    build: () => tvSessionEpisodeCubit,
    setUp: () => when(
      () => mockGetTvSessionEpissode.execute(tvId, tvSessionId, tvEpisodeId),
    ).thenAnswer(
      (_) async => const Right(episode),
    ),
    act: (bloc) => bloc.loadTvSessionEpisode(tvId, tvSessionId, tvEpisodeId),
    verify: (bloc) => verify(
      () => mockGetTvSessionEpissode.execute(tvId, tvSessionId, tvEpisodeId),
    ).called(1),
    expect: () => [
      TvSessionEpisodeLoading(),
      const TvSessionEpisodeSuccess(episode: episode)
    ],
  );

  blocTest(
    'should failure to getget tv episode and get the message',
    build: () => tvSessionEpisodeCubit,
    setUp: () => when(
      () => mockGetTvSessionEpissode.execute(tvId, tvSessionId, tvEpisodeId),
    ).thenAnswer(
      (_) async => const Left(
        ServerFailure('failed to get data episode'),
      ),
    ),
    act: (bloc) => bloc.loadTvSessionEpisode(tvId, tvSessionId, tvEpisodeId),
    verify: (bloc) => verify(
      () => mockGetTvSessionEpissode.execute(tvId, tvSessionId, tvEpisodeId),
    ).called(1),
    expect: () => [
      TvSessionEpisodeLoading(),
      const TvSessionEpisodeFailure(message: 'failed to get data episode')
    ],
  );
}
