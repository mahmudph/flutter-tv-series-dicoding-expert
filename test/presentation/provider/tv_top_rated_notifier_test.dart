import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_top_rated_notifier_test.mocks.dart';

@GenerateMocks([
  GetTopRatedTv,
])
void main() {
  late TopRatedTvNotifier provider;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TopRatedTvNotifier(getTopRatedTv: mockGetTopRatedTv);
  });

  group(
    'Test top rated tv notifier',
    () {
      test(
        'should get top rated tv with success',
        () async {
          when(mockGetTopRatedTv.execute()).thenAnswer(
            (_) async => Right(testTvList),
          );

          await provider.fetchTopRatedTv();

          verify(mockGetTopRatedTv.execute());
          expect(provider.state, RequestState.Loaded);
          expect(provider.tv, testTvList);
        },
      );

      test(
        'should get error ServerFailure when inernet not found',
        () async {
          when(mockGetTopRatedTv.execute()).thenAnswer(
            (_) async => Left(ServerFailure('server is unavailable')),
          );

          await provider.fetchTopRatedTv();

          verify(mockGetTopRatedTv.execute());

          expect(provider.tv, isEmpty);
          expect(provider.state, RequestState.Error);
          expect(provider.message, 'server is unavailable');
        },
      );

      test(
        'should get erorr ConnectionFailure when inernet not found',
        () async {
          when(mockGetTopRatedTv.execute()).thenAnswer(
            (_) async => Left(ConnectionFailure('No internet connection')),
          );

          await provider.fetchTopRatedTv();

          verify(mockGetTopRatedTv.execute());

          expect(provider.tv, isEmpty);
          expect(provider.state, RequestState.Error);
          expect(provider.message, 'No internet connection');
        },
      );
    },
  );
}
