import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv
])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late TvDetailNotifier provider;
  int listenerCallCount = 0;

  group('test tv detail notifier', () {
    setUp(() {
      mockGetTvDetail = MockGetTvDetail();
      mockGetTvRecommendations = MockGetTvRecommendations();
      mockGetWatchListTvStatus = MockGetWatchListTvStatus();
      mockSaveWatchlistTv = MockSaveWatchlistTv();
      mockRemoveWatchlistTv = MockRemoveWatchlistTv();

      provider = TvDetailNotifier(
        getTvDetail: mockGetTvDetail,
        getTvRecommendations: mockGetTvRecommendations,
        getWatchListStatus: mockGetWatchListTvStatus,
        saveWatchlist: mockSaveWatchlistTv,
        removeWatchlist: mockRemoveWatchlistTv,
      )..addListener(() {
          listenerCallCount += 1;
        });
    });

    final theId = 1;

    void arrangeUseCasesSuccess() {
      when(mockGetTvDetail.execute(theId)).thenAnswer(
        (_) async => Right(testTvDetail),
      );
      when(mockGetTvRecommendations.execute(theId)).thenAnswer(
        (_) async => Right(testTvList),
      );
    }

    void arrangeUseCasesFailure() {
      when(mockGetTvDetail.execute(theId)).thenAnswer(
        (_) async => Left(ServerFailure("")),
      );
      when(mockGetTvRecommendations.execute(theId)).thenAnswer(
        (_) async => Left(ServerFailure("")),
      );
    }

    group("Get tv detail", () {
      test(
        "should change state tv to Loading when provider is called at the first time",
        () {
          // arrange
          arrangeUseCasesSuccess();
          // act
          provider.fetchTvDetail(theId);
          // verify
          expect(provider.tvState, RequestState.Loading);
          expect(listenerCallCount, 1);
        },
      );
      test(
        "Should call usecase tv detail and the tv recomendation with success",
        () async {
          // arrange
          arrangeUseCasesSuccess();
          // act
          await provider.fetchTvDetail(theId);

          // verify
          verify(mockGetTvDetail.execute(theId));
          verify(mockGetTvRecommendations.execute(theId));

          expect(provider.tvState, RequestState.Loaded);
          expect(provider.recommendationState, RequestState.Loaded);

          expect(provider.tv, testTvDetail);
          expect(provider.tvRecommendations, testTvList);
        },
      );

      test(
        "should not called recomendation usecase tv when get the detail tv failure",
        () async {
          arrangeUseCasesFailure();

          await provider.fetchTvDetail(theId);

          verify(mockGetTvDetail.execute(theId));
          verify(mockGetTvRecommendations.execute(theId));
          expect(provider.tvState, RequestState.Error);
          expect(provider.recommendationState, RequestState.Empty);
        },
      );
    });

    group("Tv whitelist", () {
      test(
        'Should add tv item to the whitelist with success',
        () async {
          when(mockSaveWatchlistTv.execute(testTvDetail)).thenAnswer(
            (_) async => Right('Added to Watchlist'),
          );
          when(mockGetWatchListTvStatus.execute(theId)).thenAnswer(
            (_) async => true,
          );

          await provider.addWatchlist(testTvDetail);

          verify(mockSaveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(theId));

          expect(provider.isAddedToWatchlist, true);
          expect(provider.watchlistMessage, 'Added to Watchlist');
        },
      );

      test(
        'Should remove tv item to the whitelist with success',
        () async {
          when(mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
            (_) async => Right('Removed from Watchlist'),
          );

          when(mockGetWatchListTvStatus.execute(theId)).thenAnswer(
            (_) async => false,
          );

          await provider.removeFromWatchlist(testTvDetail);

          verify(mockRemoveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(theId));

          expect(provider.isAddedToWatchlist, false);
          expect(provider.watchlistMessage, 'Removed from Watchlist');
        },
      );

      test(
        "Should return true when tv detail is exist in whitelist",
        () async {
          when(mockGetWatchListTvStatus.execute(theId)).thenAnswer(
            (_) async => true,
          );

          await provider.loadWatchlistStatus(theId);

          verify(mockGetWatchListTvStatus.execute(theId));
          expect(provider.isAddedToWatchlist, true);
        },
      );
    });
  });
}
