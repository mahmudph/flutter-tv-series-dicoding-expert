import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/domain/usecases/get_tv_sessions.dart';
import 'package:tv_feature/presentation/bloc/tv_sessions/tv_session_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTvSession extends Mock implements GetTvSession {}

void main() {
  late MockGetTvSession mockGetTvSession;
  late TvSessionCubit tvSessionCubit;

  setUp(() {
    mockGetTvSession = MockGetTvSession();
    tvSessionCubit = TvSessionCubit(getTvSession: mockGetTvSession);
  });

  tearDown(() {
    tvSessionCubit.close();
  });

  const tvId = 1;
  const tvSessionId = 10;

  blocTest(
    'get success of the tv sessions',
    build: () => tvSessionCubit,
    setUp: () =>
        when(() => mockGetTvSession.execute(tvId, tvSessionId)).thenAnswer(
      (_) async => const Right(tvSession),
    ),
    act: (bloc) => bloc.getTvSessions(tvId, tvSessionId),
    verify: (bloc) => verify(
      () => mockGetTvSession.execute(tvId, tvSessionId),
    ).called(1),
    expect: () => [
      TvSessionLoading(),
      const TvSessionSuccess(session: tvSession),
    ],
  );

  blocTest(
    'get failure  of the tv sessions and get the message',
    build: () => tvSessionCubit,
    setUp: () =>
        when(() => mockGetTvSession.execute(tvId, tvSessionId)).thenAnswer(
      (_) async => const Left(
        ServerFailure('failed to get data session'),
      ),
    ),
    act: (bloc) => bloc.getTvSessions(tvId, tvSessionId),
    verify: (bloc) => verify(
      () => mockGetTvSession.execute(tvId, tvSessionId),
    ).called(1),
    expect: () => [
      TvSessionLoading(),
      const TvSessionFailure(message: 'failed to get data session')
    ],
  );
}
