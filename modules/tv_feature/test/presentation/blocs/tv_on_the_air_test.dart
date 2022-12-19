import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetOnTheAirTvShows extends Mock implements GetOnTheAirTVShows {}

void main() {
  group(
    'test tv on the air tv show cubit',
    () {
      late MockGetOnTheAirTvShows mockGetOnTheAirTvShows;
      late TvOnTheAirCubit tvPopularsCubit;

      setUp(() {
        mockGetOnTheAirTvShows = MockGetOnTheAirTvShows();
        tvPopularsCubit = TvOnTheAirCubit(
          getOnTheAirTvShow: mockGetOnTheAirTvShows,
        );
      });

      blocTest(
        'should emit TvPopularTvSuccess and get tv popular list',
        build: () => tvPopularsCubit,
        setUp: () => when(() => mockGetOnTheAirTvShows.execute()).thenAnswer(
          (_) async => Right(testTvList),
        ),
        act: (bloc) => bloc.fetchOnTheAirTvs(),
        verify: (bloc) => verify(
          () => mockGetOnTheAirTvShows.execute(),
        ),
        expect: () => [
          TvOnTheAirLoading(),
          TvOnTheAirSuccess(listOnTheAirTv: testTvList)
        ],
      );

      blocTest(
        'should emit TvPopularTvFailure and get the message of the error',
        build: () => tvPopularsCubit,
        setUp: () => when(() => mockGetOnTheAirTvShows.execute()).thenAnswer(
          (_) async => const Left(ServerFailure('No internet connection')),
        ),
        act: (bloc) => bloc.fetchOnTheAirTvs(),
        verify: (bloc) => verify(
          () => mockGetOnTheAirTvShows.execute(),
        ),
        expect: () => [
          TvOnTheAirLoading(),
          const TvOnTheAirFailure(message: 'No internet connection')
        ],
      );
    },
  );
}
