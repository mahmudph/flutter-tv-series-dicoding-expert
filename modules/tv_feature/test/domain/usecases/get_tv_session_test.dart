import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_tv_sessions.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late MockTvRepository tvRepository;
  late GetTvSession getTvSession;

  setUp(() {
    tvRepository = MockTvRepository();
    getTvSession = GetTvSession(tvRepository);
  });

  const tvId = 1;
  const tvSessionId = 10;

  test(
    'get tv sessions with success',
    () async {
      // stub
      when(() => tvRepository.getTvSession(tvId, tvSessionId)).thenAnswer(
        (_) async => const Right(tvSession),
      );

      final result = await getTvSession.execute(tvId, tvSessionId);

      /// spy
      verify(() => tvRepository.getTvSession(tvId, tvSessionId)).called(1);

      expect(result, const Right(tvSession));
    },
  );

  test(
    'get tv sessions with failure',
    () async {
      // stub
      when(() => tvRepository.getTvSession(tvId, tvSessionId)).thenAnswer(
        (_) async => const Left(ServerFailure('failed to get data sessions')),
      );

      final result = await getTvSession.execute(tvId, tvSessionId);

      /// spy
      verify(() => tvRepository.getTvSession(tvId, tvSessionId)).called(1);
      expect(result, const Left(ServerFailure('failed to get data sessions')));
    },
  );
}
