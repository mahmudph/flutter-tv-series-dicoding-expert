import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv_feature/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv_feature/domain/usecases/save_watchlist_tv.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetWatchListTvStatus extends Mock implements GetWatchListTvStatus {}

class MockSaveWatchlistTv extends Mock implements SaveWatchlistTv {}

class MockRemoveWatchlistTv extends Mock implements RemoveWatchlistTv {}

void main() {
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  late TvWatchlistStatusCubit tvWatchlistCubit;

  setUp(
    () {
      mockGetWatchListTvStatus = MockGetWatchListTvStatus();
      mockSaveWatchlistTv = MockSaveWatchlistTv();
      mockRemoveWatchlistTv = MockRemoveWatchlistTv();
      tvWatchlistCubit = TvWatchlistStatusCubit(
        getWatchListStatus: mockGetWatchListTvStatus,
        saveWatchlist: mockSaveWatchlistTv,
        removeWatchlist: mockRemoveWatchlistTv,
      );
    },
  );

  const theId = 1;

  group(
    'test get watchlist status',
    () {
      blocTest(
        'should emit state TvWatchlistStatusData and isAddedWatchlist as true',
        build: () => tvWatchlistCubit,
        setUp: () =>
            when(() => mockGetWatchListTvStatus.execute(theId)).thenAnswer(
          (_) async => true,
        ),
        act: (bloc) => bloc.loadWatchlistStatus(theId),
        verify: (bloc) => verify(
          () => mockGetWatchListTvStatus.execute(theId),
        ).called(1),
        expect: () => [
          const TvWatchlistStatusData(isAddedWatchlist: true),
        ],
        tearDown: () => tvWatchlistCubit.close(),
      );
    },
  );

  group(
    'test save tv to watchlist',
    () {
      blocTest(
        'should emit state TvWatchlistStatusData and isAddedWatchlist as true',
        build: () => tvWatchlistCubit,
        setUp: () =>
            when(() => mockSaveWatchlistTv.execute(testTvDetail)).thenAnswer(
          (_) async => const Right('Added to Watchlist'),
        ),
        act: (bloc) => bloc.addWatchlist(testTvDetail),
        verify: (bloc) => verify(
          () => mockSaveWatchlistTv.execute(testTvDetail),
        ).called(1),
        expect: () => [
          const TvWatchlistStatusData(
            isAddedWatchlist: true,
            message: 'Added to Watchlist',
          ),
        ],
        tearDown: () => tvWatchlistCubit.close(),
      );

      blocTest<TvWatchlistStatusCubit, TvWatchlistStatusState>(
        'should emit state with message failure when failed to add tv into watchlist ',
        build: () => tvWatchlistCubit,
        setUp: () =>
            when(() => mockSaveWatchlistTv.execute(testTvDetail)).thenAnswer(
          (_) async => const Left(
            DatabaseFailure('failed to add to the watchlist'),
          ),
        ),
        act: (bloc) => bloc.addWatchlist(testTvDetail),
        verify: (bloc) => verify(
          () => mockSaveWatchlistTv.execute(testTvDetail),
        ).called(1),
        expect: () => [
          const TvWatchlistStatusData(
            message: 'failed to add to the watchlist',
            isAddedWatchlist: false,
          )
        ],
        tearDown: () => tvWatchlistCubit.close(),
      );
    },
  );

  group(
    'test remove tv from watchlist',
    () {
      blocTest(
        'should emit state TvWatchlistStatusData and isAddedWatchlist as false',
        build: () => tvWatchlistCubit,
        setUp: () =>
            when(() => mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
          (_) async => const Right('Remove from Watchlist'),
        ),
        act: (bloc) => bloc.removeFromWatchlist(testTvDetail),
        verify: (bloc) => verify(
          () => mockRemoveWatchlistTv.execute(testTvDetail),
        ).called(1),
        expect: () => [
          const TvWatchlistStatusData(
            isAddedWatchlist: false,
            message: 'Remove from Watchlist',
          ),
        ],
        tearDown: () => tvWatchlistCubit.close(),
      );

      blocTest(
        'should emit state TvWatchlistStatusData with message failure when failed to add tv into watchlist ',
        build: () => tvWatchlistCubit,
        setUp: () =>
            when(() => mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
          (_) async => const Left(
            DatabaseFailure('failed to remove tvto the watchlist'),
          ),
        ),
        act: (bloc) => bloc.removeFromWatchlist(testTvDetail),
        verify: (bloc) => verify(
          () => mockRemoveWatchlistTv.execute(testTvDetail),
        ).called(1),
        expect: () => [
          const TvWatchlistStatusData(
            isAddedWatchlist: true,
            message: 'failed to remove tvto the watchlist',
          )
        ],
        tearDown: () => tvWatchlistCubit.close(),
      );
    },
  );
}
