import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_popular_tv.dart';
import 'package:tv_feature/presentation/bloc/tv_populars/tv_populars_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetPopularTv extends Mock implements GetPopularTv {}

void main() {
  group(
    'test tv popular cubit',
    () {
      late MockGetPopularTv mockGetPopularTv;
      late TvPopularsCubit tvPopularsCubit;

      setUp(() {
        mockGetPopularTv = MockGetPopularTv();
        tvPopularsCubit = TvPopularsCubit(
          getPopularTv: mockGetPopularTv,
        );
      });

      blocTest(
        'should emit TvPopularTvSuccess and get tv popular list',
        build: () => tvPopularsCubit,
        setUp: () => when(() => mockGetPopularTv.execute()).thenAnswer(
          (_) async => Right(testTvList),
        ),
        act: (bloc) => bloc.fetchPopulartv(),
        verify: (bloc) => verify(
          () => mockGetPopularTv.execute(),
        ),
        expect: () => [
          TvPopularTvLoading(),
          TvPopularTvSuccess(listPopularTvTv: testTvList)
        ],
      );

      blocTest(
        'should emit TvPopularTvFailure and get the message of the error',
        build: () => tvPopularsCubit,
        setUp: () => when(() => mockGetPopularTv.execute()).thenAnswer(
          (_) async => const Left(ServerFailure('No internet connection')),
        ),
        act: (bloc) => bloc.fetchPopulartv(),
        verify: (bloc) => verify(
          () => mockGetPopularTv.execute(),
        ),
        expect: () => [
          TvPopularTvLoading(),
          const TvPopularTvFailure(message: 'No internet connection')
        ],
      );
    },
  );
}
