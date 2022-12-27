import 'package:bloc_test/bloc_test.dart';
import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/bloc/tv_details/tv_details_cubit.dart';
import 'package:tv_feature/presentation/widgets/tv_seasson_list.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvDetailCubit extends MockCubit<TvDetailsState>
    implements TvDetailsCubit {}

class TvDetailStateFake extends Fake implements TvDetailsState {}

class MockTvRecommendationCubit extends MockCubit<TvRecomendationsState>
    implements TvRecomendationsCubit {}

class MockTvWatchlistStatusCubit extends MockCubit<TvWatchlistStatusState>
    implements TvWatchlistStatusCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockTvDetailCubit tvDetailCubit;
  late MockTvRecommendationCubit tvRecommendationCubit;
  late MockTvWatchlistStatusCubit tvWatchlistStatusCubit;
  late MockNavigatorObserver mockNavigatorObserver;

  final eventRoute = MaterialPageRoute(builder: (_) => Container());

  setUp(() {
    tvDetailCubit = MockTvDetailCubit();
    tvRecommendationCubit = MockTvRecommendationCubit();
    tvWatchlistStatusCubit = MockTvWatchlistStatusCubit();
    mockNavigatorObserver = MockNavigatorObserver();

    registerFallbackValue(TvDetailStateFake());
    registerFallbackValue(FakeRoute());
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
        navigatorObservers: [mockNavigatorObserver],
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
            case TvSessionPage.route:
              return eventRoute;
          }
          return null;
        },
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

  testWidgets(
    'When button is being click then it should invoke method addWatchlist when tv is not exist in watchlist',
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

      final elevatedBtn = find.byType(ElevatedButton);
      expect(elevatedBtn, findsOneWidget);

      await tester.tap(elevatedBtn);
      await tester.pump();

      verify(
        () => tvWatchlistStatusCubit.addWatchlist(testTvDetail),
      ).called(1);
    },
  );

  testWidgets(
    'When button is being click then it should invoke method removeFromWatchlist when exist',
    (WidgetTester tester) async {
      /// stub for initial state
      mockFetchInitialData();

      when(() => tvWatchlistStatusCubit.removeFromWatchlist(testTvDetail))
          .thenAnswer(
        (_) async => {},
      );

      when(() => tvDetailCubit.state).thenReturn(
        TvDetailsSuccess(tvDetail: testTvDetail),
      );

      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecommendationSuccess(listRecomendationsTv: testTvList),
      );

      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(isAddedWatchlist: true),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

      final elevatedBtn = find.byType(ElevatedButton);
      expect(elevatedBtn, findsOneWidget);

      await tester.tap(elevatedBtn);
      await tester.pump();

      verify(
        () => tvWatchlistStatusCubit.removeFromWatchlist(testTvDetail),
      ).called(1);
    },
  );

  testWidgets(
    'should show message erorr get tv detail is failed',
    (WidgetTester tester) async {
      /// stub for initial state
      mockFetchInitialData();

      when(() => tvDetailCubit.state).thenReturn(
        const TvDetailsFailure(message: 'failed to get tv detail'),
      );

      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecommendationSuccess(listRecomendationsTv: testTvList),
      );

      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(isAddedWatchlist: true),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.byType(InformationWidget), findsOneWidget);
    },
  );

  testWidgets(
    'should navigate to the tv session detail when spesific session is press',
    (WidgetTester tester) async {
      /// mock tv table
      final testTvDetail = TvDetail(
        backdropPath: 'backdropPath',
        episodeRunTime: const [1],
        firstAirDate: DateTime.parse('2010-22-10'),
        genres: const [],
        homepage: 'homepage',
        id: 1,
        inProduction: true,
        languages: const ['languages'],
        lastAirDate: DateTime.parse('2010-22-10'),
        name: 'name',
        nextEpisodeToAir: 'nextEpisodeToAir',
        numberOfEpisodes: 12,
        numberOfSeasons: 12,
        originCountry: const ['originCountry'],
        originalLanguage: 'originalLanguage',
        originalName: 'originalName',
        overview: 'overview',
        popularity: 3.2,
        posterPath: 'posterPath',
        seasons: const [
          Season(
            airDate: '2022-10-14',
            episodeCount: 1,
            id: 1,
            name: 'name',
            overview: 'overview',
            posterPath: 'posterPath',
            seasonNumber: 2,
          )
        ],
        status: 'status',
        tagline: 'tagline',
        type: 'type',
        voteAverage: 10.0,
        voteCount: 1000,
      );

      /// stub for initial state
      mockFetchInitialData();

      when(() => tvDetailCubit.state).thenReturn(
        TvDetailsSuccess(tvDetail: testTvDetail),
      );

      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecommendationSuccess(listRecomendationsTv: testTvList),
      );

      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(isAddedWatchlist: true),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

      final tvSessionList = find.byType(TvSeasson);

      expect(tvSessionList, findsOneWidget);

      await tester.tap(tvSessionList.first, warnIfMissed: false);
      await tester.pump();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
    },
  );

  testWidgets(
    'should navigate to the tv detail when back button is press',
    (tester) async {
      /// stub for initial state
      mockFetchInitialData();

      when(() => tvDetailCubit.state).thenReturn(
        TvDetailsSuccess(tvDetail: testTvDetail),
      );

      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecommendationSuccess(listRecomendationsTv: testTvList),
      );

      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(isAddedWatchlist: true),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

      final backButtonIcon = find.byType(IconButton);
      expect(backButtonIcon, findsOneWidget);

      await tester.tap(backButtonIcon);
      await tester.pump();

      verify(
        () => mockNavigatorObserver.didPop(any(), any()),
      ).called(1);
    },
  );

  testWidgets(
    'should navigate to the tv detail with spesific id',
    (tester) async {
      /// stub for initial state
      mockFetchInitialData();

      when(() => tvDetailCubit.state).thenReturn(
        TvDetailsSuccess(tvDetail: testTvDetail),
      );

      when(() => tvRecommendationCubit.state).thenReturn(
        TvRecommendationSuccess(listRecomendationsTv: testTvList),
      );

      when(() => tvWatchlistStatusCubit.state).thenReturn(
        const TvWatchlistStatusData(isAddedWatchlist: true),
      );

      await tester.pumpWidget(makeTestableWidget(const TvDetailPage(id: 1)));

      final recomendationListView = find.byKey(
        const Key('tv_recommendation_list'),
      );

      expect(recomendationListView, findsOneWidget);

      /// find item inkwell
      final inkRecommendationItem = find.descendant(
        of: recomendationListView,
        matching: find.byType(InkWell),
      );

      expect(inkRecommendationItem, findsWidgets);

      await tester.tap(inkRecommendationItem.first);
      await tester.pump();

      verify(
        () => mockNavigatorObserver.didPush(any(), any()),
      ).called(1);
    },
  );
}
