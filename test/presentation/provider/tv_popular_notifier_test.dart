import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/popular_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_popular_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late GetPopularTv mockGetPopularTv;
  late PopularTvNotifier provider;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    provider = PopularTvNotifier(getPopularTv: mockGetPopularTv);
  });

  group('Test popular tv notifier', () {
    test(
      'Should get popular tv with success',
      () async {
        when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => Right(testTvList),
        );
        // act
        await provider.fetchPopulartv();
        // asert
        verify(mockGetPopularTv.execute());
        expect(provider.state, RequestState.Loaded);
      },
    );

    test(
      'Should get popular tv with server failure when server is eror',
      () async {
        when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => Left(ServerFailure('')),
        );
        // act
        await provider.fetchPopulartv();
        // asert
        verify(mockGetPopularTv.execute());

        expect(provider.message, '');
        expect(provider.tv, isEmpty);
        expect(provider.state, RequestState.Error);
      },
    );

    test(
      'Should get message network connection is failure when no internet connection',
      () async {
        when(mockGetPopularTv.execute()).thenAnswer(
          (_) async => Left(
            ConnectionFailure(
              'Failed to connect to the network',
            ),
          ),
        );
        // act
        await provider.fetchPopulartv();
        // asert
        verify(mockGetPopularTv.execute());
        expect(provider.state, RequestState.Error);
        expect(provider.message, 'Failed to connect to the network');
      },
    );
  });
}
