import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_tv_session_episode.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late MockTvRepository tvRepository;
  late GetTvSessionEpisode getTvSessionEpisode;

  setUp(() {
    tvRepository = MockTvRepository();
    getTvSessionEpisode = GetTvSessionEpisode(tvRepository: tvRepository);
  });

  const tvId = 1;
  const tvSessionId = 10;
  const tvSessionEpisodeId = 2;

  test(
    'get tv sessions with success',
    () async {
      // stub
      when(
        () => tvRepository.getEpisodeBySession(
          tvId,
          tvSessionId,
          tvSessionEpisodeId,
        ),
      ).thenAnswer(
        (_) async => const Right(episode),
      );

      final result = await getTvSessionEpisode.execute(
        tvId,
        tvSessionId,
        tvSessionEpisodeId,
      );

      /// spy
      verify(
        () => tvRepository.getEpisodeBySession(
          tvId,
          tvSessionId,
          tvSessionEpisodeId,
        ),
      ).called(1);

      expect(result, const Right(episode));
    },
  );

  test(
    'get tv sessions with failure',
    () async {
      // stub
      when(
        () => tvRepository.getEpisodeBySession(
          tvId,
          tvSessionId,
          tvSessionEpisodeId,
        ),
      ).thenAnswer(
        (_) async => const Left(ServerFailure('failed to get data sessions')),
      );

      final result = await getTvSessionEpisode.execute(
        tvId,
        tvSessionId,
        tvSessionEpisodeId,
      );

      /// spy
      verify(
        () => tvRepository.getEpisodeBySession(
          tvId,
          tvSessionId,
          tvSessionEpisodeId,
        ),
      ).called(1);

      expect(result, const Left(ServerFailure('failed to get data sessions')));
    },
  );
}
