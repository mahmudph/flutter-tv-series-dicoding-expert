import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/domain/usecases/get_watchlist_tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvWatchlistList extends Mock implements GetWatchlistTv {}

void main() {
  group('watchlist tv list cubit', () {
    late MockTvWatchlistList mockTvWatchlistList;
    late TvWatchlistCubit tvWatchlistCubit;

    setUp(() {
      mockTvWatchlistList = MockTvWatchlistList();
      tvWatchlistCubit = TvWatchlistCubit(getWatchlistTv: mockTvWatchlistList);
    });

    blocTest(
      'should emit TvWatchlistSuccess and get the list of tv watchlist',
      build: () => tvWatchlistCubit,
      setUp: () => when(() => mockTvWatchlistList.execute()).thenAnswer(
        (_) async => Right(testTvList),
      ),
      tearDown: () => tvWatchlistCubit.close(),
      act: (bloc) => bloc.loadTvWatchlist(),
      verify: (bloc) => verify(
        () => mockTvWatchlistList.execute(),
      ),
      expect: () => [
        TvWatchlistLoading(),
        TvWatchlistSuccess(tv: testTvList),
      ],
    );

    blocTest(
      'should emit TvTopRatedTvFailure and get the message of the error',
      build: () => tvWatchlistCubit,
      setUp: () => when(() => mockTvWatchlistList.execute()).thenAnswer(
        (_) async => const Left(DatabaseFailure('something wen\'t wrong')),
      ),
      act: (bloc) => bloc.loadTvWatchlist(),
      verify: (bloc) => verify(
        () => mockTvWatchlistList.execute(),
      ),
      tearDown: () => tvWatchlistCubit.close(),
      expect: () => [
        TvWatchlistLoading(),
        const TvWatchlistFailure(message: 'something wen\'t wrong')
      ],
    );
  });
}
