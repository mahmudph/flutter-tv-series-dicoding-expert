import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/presentation/bloc/tv_details/tv_details_cubit.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvDetailCubit extends MockCubit<TvDetailsState>
    implements TvDetailsCubit {}

class TvDetailStateFake extends Fake implements TvDetailsState {}

class MockTvRecommendationCubit extends MockCubit<TvRecomendationsState>
    implements TvRecomendationsCubit {}

class MockTvWatchlistStatusCubit extends MockCubit<TvWatchlistStatusState>
    implements TvWatchlistStatusCubit {}

void main() {
  late MockTvDetailCubit tvDetailCubit;
  late MockTvRecommendationCubit tvRecommendationCubit;
  late MockTvWatchlistStatusCubit tvWatchlistStatusCubit;

  setUpAll(() {
    registerFallbackValue(TvDetailStateFake());
  });

  setUp(() {
    tvDetailCubit = MockTvDetailCubit();
    tvRecommendationCubit = MockTvRecommendationCubit();
    tvWatchlistStatusCubit = MockTvWatchlistStatusCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailsCubit>.value(value: tvDetailCubit),
        BlocProvider<TvRecomendationsCubit>.value(
          value: tvRecommendationCubit,
        ),
        BlocProvider<TvWatchlistStatusCubit>.value(
          value: tvWatchlistStatusCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const theId = 1;

  void mockFetchInitialData() {
    when(() => tvDetailCubit.fetchTvDetail(theId)).thenAnswer((_) async => {});
    when(() => tvRecommendationCubit.loadTvRecommendations(theId)).thenAnswer(
      (_) async => {},
    );
    when(() => tvWatchlistStatusCubit.loadWatchlistStatus(theId)).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should display circular progress indicator when state tv detail is TvDetailsLoading',
    (WidgetTester tester) async {
      /// stub for initial state
      mockFetchInitialData();

      /// stub for state
      when(() => tvDetailCubit.state).thenReturn(TvDetailsLoading());
      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecomendationsInitial(),
      );
      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(),
      );

      await tester.pumpWidget(
        makeTestableWidget(const TvDetailPage(id: theId)),
      );

      final loading = find.byType(CircularProgressIndicator);
      expect(loading, findsOneWidget);
    },
  );

  testWidgets(
    'Should show tv detail and the sessions when state of the tv detail is TvDetailsSuccess',
    (WidgetTester tester) async {
      /// stub for initial state
      mockFetchInitialData();

      when(() => tvDetailCubit.state).thenReturn(
        TvDetailsSuccess(tvDetail: testTvDetail),
      );
      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecomendationsInitial(),
      );
      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      final detailTvContent = find.byType(DetailContent);
      final tvSessionList = find.byKey(const Key('list_tv_sessions'));

      expect(detailTvContent, findsOneWidget);
      expect(tvSessionList, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display add icon when tv is not being added to watchlist',
    (WidgetTester tester) async {
      /// stub for initial state
      mockFetchInitialData();

      when(() => tvWatchlistStatusCubit.addWatchlist(testTvDetail)).thenAnswer(
        (_) async => {},
      );

      when(() => tvDetailCubit.state).thenReturn(
        TvDetailsSuccess(tvDetail: testTvDetail),
      );

      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecommendationSuccess(listRecomendationsTv: testTvList),
      );

      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Tv detail should display list of recomendation tv when state tvRecommendationCubit is TvRecommendationSuccess',
    (WidgetTester tester) async {
      /// stub for initial state
      mockFetchInitialData();

      when(() => tvWatchlistStatusCubit.addWatchlist(testTvDetail)).thenAnswer(
        (_) async => {},
      );

      when(() => tvDetailCubit.state).thenReturn(
        TvDetailsSuccess(tvDetail: testTvDetail),
      );

      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecommendationSuccess(listRecomendationsTv: testTvList),
      );

      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));
      expect(find.byKey(const Key('tv_recommendation_list')), findsOneWidget);
    },
  );
}
