import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_tv.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late MockSearchTv mockSearchTv;
  late TvSearchNotifier provider;

  setUp(() {
    mockSearchTv = MockSearchTv();
    provider = TvSearchNotifier(searchTv: mockSearchTv);
  });

  final query = 'nikita';

  group('tv search notifier', () {
    test(
      'should get with success state and not empty data',
      () async {
        when(mockSearchTv.execute(query)).thenAnswer(
          (_) async => Right(testTvList),
        );

        await provider.fetchTvSearch(query);

        verify(mockSearchTv.execute(query));
        expect(provider.state, RequestState.Loaded);
        expect(provider.searchResult, isNotEmpty);
        expect(provider.searchResult, testTvList);
      },
    );

    test(
      'should get with error ConnectionFailure',
      () async {
        when(mockSearchTv.execute(query)).thenAnswer(
          (_) async => Left(
            ConnectionFailure('no internet connection'),
          ),
        );

        await provider.fetchTvSearch(query);

        verify(mockSearchTv.execute(query));
        expect(provider.state, RequestState.Error);
        expect(provider.searchResult, isEmpty);
        expect(provider.message, 'no internet connection');
      },
    );

    test(
      'should get with error ServerFailure',
      () async {
        when(mockSearchTv.execute(query)).thenAnswer(
          (_) async => Left(
            ServerFailure('server is not available'),
          ),
        );

        await provider.fetchTvSearch(query);

        verify(mockSearchTv.execute(query));
        expect(provider.state, RequestState.Error);
        expect(provider.searchResult, isEmpty);
        expect(provider.message, 'server is not available');
      },
    );
  });
}
