import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_tv_detail.dart';
import 'package:tv_feature/presentation/bloc/tv_details/tv_details_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTvDetails extends Mock implements GetTvDetail {}

void main() {
  group(
    'test get tv detail cubit',
    () {
      late MockGetTvDetails mockGetTvDetails;
      late TvDetailsCubit tvDetailsCubit;

      setUp(
        () {
          mockGetTvDetails = MockGetTvDetails();
          tvDetailsCubit = TvDetailsCubit(getTvDetail: mockGetTvDetails);
        },
      );

      const theId = 1;

      blocTest(
        'should emit state TvDetailsSuccess and get the detail tv based id',
        build: () => tvDetailsCubit,
        setUp: () => when(() => mockGetTvDetails.execute(theId)).thenAnswer(
          (_) async => Right(testTvDetail),
        ),
        act: (bloc) => bloc.fetchTvDetail(theId),
        verify: (bloc) => verify(
          () => mockGetTvDetails.execute(theId),
        ).called(1),
        expect: () => [
          TvDetailsLoading(),
          TvDetailsSuccess(tvDetail: testTvDetail),
        ],
        tearDown: () => tvDetailsCubit.close(),
      );

      blocTest(
        'should emit TvDetailsFailure when no internet connection and get the message',
        build: () => tvDetailsCubit,
        setUp: () => when(() => mockGetTvDetails.execute(theId)).thenAnswer(
          (_) async => const Left(ServerFailure('no internet connection')),
        ),
        act: (bloc) => bloc.fetchTvDetail(theId),
        verify: (bloc) => verify(
          () => mockGetTvDetails.execute(theId),
        ).called(1),
        expect: () => [
          TvDetailsLoading(),
          const TvDetailsFailure(message: 'no internet connection'),
        ],
        tearDown: () => tvDetailsCubit.close(),
      );
    },
  );
}
