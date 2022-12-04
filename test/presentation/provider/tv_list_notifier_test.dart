import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetOnTheAirTVShows,
  GetPopularTv,
  GetTopRatedTv,
])
void main() {
  late MockGetOnTheAirTVShows mockGetOnTheAirTVShows;
  late MockGetPopularTv mockGetPopularTv;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TvListNotifier provider;

  setUp(() {
    mockGetOnTheAirTVShows = MockGetOnTheAirTVShows();
    mockGetPopularTv = MockGetPopularTv();
    mockGetTopRatedTv = MockGetTopRatedTv();
    provider = TvListNotifier(
      getOnTheAirTvShow: mockGetOnTheAirTVShows,
      getPopularTv: mockGetPopularTv,
      getTopRatedTv: mockGetTopRatedTv,
    );
  });

  group(
    'test tv list notifier',
    () {
      group('on the air tv show', () {
        test(
          'should get success state',
          () async {
            when(mockGetOnTheAirTVShows.execute()).thenAnswer(
              (_) async => Right(testTvList),
            );

            await provider.fetchOnTheAirTvShow();

            verify(mockGetOnTheAirTVShows.execute());

            expect(provider.onTheAirTvShowTv, testTvList);
            expect(provider.onTheAirTvShowState, RequestState.Loaded);
          },
        );

        test(
          'should get error ServerFailure',
          () async {
            when(mockGetOnTheAirTVShows.execute()).thenAnswer(
              (_) async => Left(ServerFailure('server unavailable')),
            );

            await provider.fetchOnTheAirTvShow();

            verify(mockGetOnTheAirTVShows.execute());

            expect(provider.onTheAirTvShowTv, isEmpty);
            expect(provider.onTheAirTvShowState, RequestState.Error);
            expect(provider.message, 'server unavailable');
          },
        );

        test(
          'should get error ConnectionFailure',
          () async {
            when(mockGetOnTheAirTVShows.execute()).thenAnswer(
              (_) async => Left(ConnectionFailure('no internet connection')),
            );

            await provider.fetchOnTheAirTvShow();

            verify(mockGetOnTheAirTVShows.execute());

            expect(provider.onTheAirTvShowTv, isEmpty);
            expect(provider.onTheAirTvShowState, RequestState.Error);
            expect(provider.message, 'no internet connection');
          },
        );
      });

      group('popular tv show', () {
        test(
          'should get with success state',
          () async {
            when(mockGetPopularTv.execute()).thenAnswer(
              (_) async => Right(testTvList),
            );

            await provider.fetchPopularTv();
            verify(mockGetPopularTv.execute());
            expect(provider.popularTvState, RequestState.Loaded);
            expect(provider.popularTv, isNotEmpty);
            expect(provider.popularTv, testTvList);
          },
        );

        test(
          'should get error ConnectionFailure state',
          () async {
            when(mockGetPopularTv.execute()).thenAnswer(
              (_) async => Left(ConnectionFailure('no internet connection')),
            );

            await provider.fetchPopularTv();
            verify(mockGetPopularTv.execute());
            expect(provider.popularTvState, RequestState.Error);
            expect(provider.popularTv, isEmpty);
            expect(provider.message, 'no internet connection');
          },
        );

        test('should get error ServerFailure state', () async {
          when(mockGetPopularTv.execute()).thenAnswer(
            (_) async => Left(ConnectionFailure('server unavailable')),
          );

          await provider.fetchPopularTv();
          verify(mockGetPopularTv.execute());
          expect(provider.popularTvState, RequestState.Error);
          expect(provider.popularTv, isEmpty);
          expect(provider.message, 'server unavailable');
        });
      });

      group(
        'top rated tv',
        () {
          test(
            'should get with success state',
            () async {
              when(mockGetTopRatedTv.execute()).thenAnswer(
                (_) async => Right(testTvList),
              );

              await provider.fetchTopRatedTv();

              verify(mockGetTopRatedTv.execute());
              expect(provider.topRatedTvState, RequestState.Loaded);
              expect(provider.topRatedTv, isNotEmpty);
              expect(provider.topRatedTv, testTvList);
            },
          );
          test(
            'should get error ConnectionFailure state',
            () async {
              when(mockGetTopRatedTv.execute()).thenAnswer(
                (_) async => Left(ConnectionFailure('no internet connection')),
              );

              await provider.fetchTopRatedTv();
              verify(mockGetTopRatedTv.execute());
              expect(provider.topRatedTvState, RequestState.Error);
              expect(provider.topRatedTv, isEmpty);
              expect(provider.message, 'no internet connection');
            },
          );

          test('should get error ServerFailure state', () async {
            when(mockGetTopRatedTv.execute()).thenAnswer(
              (_) async => Left(ConnectionFailure('server unavailable')),
            );

            await provider.fetchTopRatedTv();
            verify(mockGetTopRatedTv.execute());
            expect(provider.topRatedTvState, RequestState.Error);
            expect(provider.topRatedTv, isEmpty);
            expect(provider.message, 'server unavailable');
          });
        },
      );
    },
  );
}
