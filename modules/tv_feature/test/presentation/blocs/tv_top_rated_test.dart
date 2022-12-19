import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/domain/usecases/get_top_rated_tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTopRatedTv extends Mock implements GetTopRatedTv {}

void main() {
  group(
    'test top rated tv',
    () {
      late MockGetTopRatedTv mockGetTopRatedTv;
      late TvTopRatedCubit tvTopRatedCubit;

      setUp(() {
        mockGetTopRatedTv = MockGetTopRatedTv();
        tvTopRatedCubit = TvTopRatedCubit(
          getTopRatedTv: mockGetTopRatedTv,
        );
      });

      blocTest(
        'should emit TvTopRatedTvSuccess and get tv top rated list',
        build: () => tvTopRatedCubit,
        setUp: () => when(() => mockGetTopRatedTv.execute()).thenAnswer(
          (_) async => Right(testTvList),
        ),
        tearDown: () => tvTopRatedCubit.close(),
        act: (bloc) => bloc.fetchTopRatedTv(),
        verify: (bloc) => verify(
          () => mockGetTopRatedTv.execute(),
        ),
        expect: () => [
          TvTopRatedTvLoading(),
          TvTopRatedTvSuccess(listTopRatedTv: testTvList)
        ],
      );

      blocTest(
        'should emit TvTopRatedTvFailure and get the message of the error',
        build: () => tvTopRatedCubit,
        setUp: () => when(() => mockGetTopRatedTv.execute()).thenAnswer(
          (_) async => const Left(ServerFailure('No internet connection')),
        ),
        act: (bloc) => bloc.fetchTopRatedTv(),
        verify: (bloc) => verify(
          () => mockGetTopRatedTv.execute(),
        ),
        tearDown: () => tvTopRatedCubit.close(),
        expect: () => [
          TvTopRatedTvLoading(),
          const TvTopRatedTvFailure(message: 'No internet connection')
        ],
      );
    },
  );
}
