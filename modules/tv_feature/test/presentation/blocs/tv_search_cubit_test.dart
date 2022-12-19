import 'package:bloc_test/bloc_test.dart';
import 'package:core/commons/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/domain/usecases/search_tv.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchTv extends Mock implements SearchTv {}

void main() {
  const query = 'spidermant';
  group(
    'test tv cubit',
    () {
      late MockSearchTv mockSearchTv;
      late TvSearchCubit bloc;

      setUp(() {
        mockSearchTv = MockSearchTv();
        bloc = TvSearchCubit(searchTv: mockSearchTv);
      });

      blocTest<TvSearchCubit, TvSearchState>(
        'should emit search success when search movies',
        build: () => bloc,
        act: (bloc) => bloc.searchTvByQuery(query),
        setUp: () => when(() => mockSearchTv.execute(query)).thenAnswer(
          (_) async => Right(testTvList),
        ),
        tearDown: () => bloc.close(),
        verify: (bloc) {
          verify(() => mockSearchTv.execute(query)).called(1);
        },
        expect: () => [
          TvSearchLoading(),
          TvSearchSuccess(tv: testTvList),
        ],
      );

      blocTest<TvSearchCubit, TvSearchState>(
        'should emit search failure when no internet connection available',
        build: () => bloc,
        act: (bloc) => bloc.searchTvByQuery(query),
        setUp: () => when(() => mockSearchTv.execute(query)).thenAnswer(
          (_) async => const Left(ServerFailure('No internet connection')),
        ),
        tearDown: () => bloc.close(),
        verify: (bloc) {
          verify(() => mockSearchTv.execute(query)).called(1);
        },
        expect: () => [
          TvSearchLoading(),
          const TvSearchFailure(message: 'No internet connection')
        ],
      );
    },
  );
}
