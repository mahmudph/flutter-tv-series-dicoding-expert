import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_feature/presentation/bloc/tv_recomendations/tv_recomendations_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTvRecommendation extends Mock implements GetTvRecommendations {}

void main() {
  group(
    'test recommendation',
    () {
      late MockGetTvRecommendation getTvRecommendations;
      late TvRecomendationsCubit tvRecomendationsCubit;

      setUp(() {
        getTvRecommendations = MockGetTvRecommendation();
        tvRecomendationsCubit = TvRecomendationsCubit(
          tvRecommendations: getTvRecommendations,
        );
      });

      const theTvId = 1;

      blocTest(
        'should emit TvRecommendationSuccess and get tv recommendation list',
        build: () => tvRecomendationsCubit,
        setUp: () =>
            when(() => getTvRecommendations.execute(theTvId)).thenAnswer(
          (_) async => Right(testTvList),
        ),
        act: (bloc) => bloc.loadTvRecommendations(theTvId),
        verify: (bloc) => verify(
          () => getTvRecommendations.execute(theTvId),
        ),
        expect: () => [
          TvRecommendationLoading(),
          TvRecommendationSuccess(listRecomendationsTv: testTvList)
        ],
      );

      blocTest(
        'should emit TvRecommendationFailure and get the message of the error',
        build: () => tvRecomendationsCubit,
        setUp: () =>
            when(() => getTvRecommendations.execute(theTvId)).thenAnswer(
          (_) async => const Left(ServerFailure('No internet connection')),
        ),
        act: (bloc) => bloc.loadTvRecommendations(theTvId),
        verify: (bloc) => verify(
          () => getTvRecommendations.execute(theTvId),
        ),
        expect: () => [
          TvRecommendationLoading(),
          const TvRecommendationFailure(message: 'No internet connection')
        ],
      );
    },
  );
}
