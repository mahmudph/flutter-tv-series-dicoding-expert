import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvPopularsCubit extends MockCubit<TvPopularsState>
    implements TvPopularsCubit {}

class MockTvTopRatedCubit extends MockCubit<TvTopRatedState>
    implements TvTopRatedCubit {}

class MockTvOnTheAirCubit extends MockCubit<TvOnTheAirState>
    implements TvOnTheAirCubit {}

class MockNavigtionObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockTvPopularsCubit mockTvPopularsCubit;
  late MockTvTopRatedCubit mockTvTopRatedCubit;
  late MockTvOnTheAirCubit mockTvOnTheAirCubit;
  late MockNavigtionObserver mockNavigtionObserver;

  setUp(() {
    mockTvOnTheAirCubit = MockTvOnTheAirCubit();
    mockTvPopularsCubit = MockTvPopularsCubit();
    mockTvTopRatedCubit = MockTvTopRatedCubit();
    mockNavigtionObserver = MockNavigtionObserver();
  });

  final evenRoutePopularMovie = MaterialPageRoute(builder: (_) => Container());
  final evenRouteTopRatedMovie = MaterialPageRoute(builder: (_) => Container());
  final evenRouteSearchMovie = MaterialPageRoute(builder: (_) => Container());

  Widget makeTestableWidget(
    Widget body,
    MockNavigtionObserver navigationObserver,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvPopularsCubit>.value(value: mockTvPopularsCubit),
        BlocProvider<TvTopRatedCubit>.value(value: mockTvTopRatedCubit),
        BlocProvider<TvOnTheAirCubit>.value(value: mockTvOnTheAirCubit),
      ],
      child: MaterialApp(
        navigatorObservers: [navigationObserver],
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case TvPopularsPage.route:
              return evenRoutePopularMovie;
            case TvTopRatedPage.route:
              return evenRouteTopRatedMovie;
            case TvDetailPage.route:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case TvSearchPage.route:
              return evenRouteSearchMovie;
          }
          return null;
        },
        home: body,
      ),
    );
  }

  void provideStubProvider({
    required TvTopRatedState tvTopRatedState,
    required TvPopularsState tvPopularsState,
    required TvOnTheAirState tvOnTheAirState,
  }) {
    when(() => mockTvTopRatedCubit.state).thenReturn(tvTopRatedState);
    when(() => mockTvPopularsCubit.state).thenReturn(tvPopularsState);
    when(() => mockTvOnTheAirCubit.state).thenReturn(tvOnTheAirState);

    when(() => mockTvTopRatedCubit.fetchTopRatedTv()).thenAnswer(
      (_) async => {},
    );
    when(() => mockTvPopularsCubit.fetchPopulartv()).thenAnswer(
      (_) async => {},
    );
    when(() => mockTvOnTheAirCubit.fetchOnTheAirTvs()).thenAnswer(
      (_) async => {},
    );
  }

  Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  testWidgets(
    'should show loading when state home movie page is loading',
    (WidgetTester tester) async {
      /// stub
      provideStubProvider(
        tvOnTheAirState: TvOnTheAirLoading(),
        tvPopularsState: TvPopularTvLoading(),
        tvTopRatedState: TvTopRatedTvLoading(),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const TvHomePage(
            onPressAbout: 'onPressAbout',
            onPressWatchlist: 'onPressWatchlist',
            onPressMovies: 'onPressTv',
          ),
          mockNavigtionObserver,
        ),
      );

      final loading = find.byType(CircularProgressIndicator);

      /// find loading
      final topRatedLoading = findByKey('top_rated_tv_loading');
      final nowPlayingLoading = findByKey('on_the_air_tv_loading');
      final popularLoading = findByKey('popular_tv_loading');

      expect(loading, findsNWidgets(3));

      expect(topRatedLoading, findsOneWidget);
      expect(nowPlayingLoading, findsOneWidget);
      expect(popularLoading, findsOneWidget);
    },
  );

  testWidgets(
    'should show movie data when state is success',
    (WidgetTester tester) async {
      /// stub
      provideStubProvider(
        tvOnTheAirState: TvOnTheAirSuccess(listOnTheAirTv: testTvList),
        tvPopularsState: TvPopularTvSuccess(listPopularTvTv: testTvList),
        tvTopRatedState: TvTopRatedTvSuccess(listTopRatedTv: testTvList),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const TvHomePage(
            onPressAbout: 'onPressAbout',
            onPressWatchlist: 'onPressWatchlist',
            onPressMovies: 'onPressTv',
          ),
          mockNavigtionObserver,
        ),
      );

      /// find loading
      final topRatedLoading = findByKey('top_rated_tv_loading');
      final nowPlayingLoading = findByKey('on_the_air_tv_loading');
      final popularLoading = findByKey('popular_tv_loading');

      /// list tv data
      final topRatedListMovie = findByKey('top_rated_tv_list');
      final nowPlayingMovie = findByKey('on_the_air_tv_list');
      final popularMovie = findByKey('populars_tv_list');

      expect(topRatedLoading, findsNothing);
      expect(nowPlayingLoading, findsNothing);
      expect(popularLoading, findsNothing);

      expect(topRatedListMovie, findsOneWidget);
      expect(nowPlayingMovie, findsOneWidget);
      expect(popularMovie, findsOneWidget);
    },
  );

  testWidgets(
    'should show message error  when state is errror',
    (WidgetTester tester) async {
      /// stub
      ///
      provideStubProvider(
        tvOnTheAirState: const TvOnTheAirFailure(
          message: 'failed to get data ',
        ),
        tvPopularsState: const TvPopularTvFailure(
          message: 'failed to get data ',
        ),
        tvTopRatedState: const TvTopRatedTvFailure(
          message: 'failed to get data ',
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const TvHomePage(
            onPressAbout: 'onPressAbout',
            onPressWatchlist: 'onPressWatchlist',
            onPressMovies: 'onPressMovie',
          ),
          mockNavigtionObserver,
        ),
      );

      /// find loading
      final topRatedLoading = findByKey('top_rated_tv_loading');
      final nowPlayingLoading = findByKey('on_the_air_tv_loading');
      final popularLoading = findByKey('popular_tv_loading');

      /// list tv data
      final topRatedListMovie = findByKey('top_rated_tv_list');
      final nowPlayingMovie = findByKey('on_the_air_tv_list');
      final popularMovie = findByKey('popular_tv_list');

      expect(topRatedLoading, findsNothing);
      expect(nowPlayingLoading, findsNothing);
      expect(popularLoading, findsNothing);

      expect(topRatedListMovie, findsNothing);
      expect(nowPlayingMovie, findsNothing);
      expect(popularMovie, findsNothing);

      /// errors
      expect(find.text('failed to get data '), findsNWidgets(3));
    },
  );

  testWidgets(
    'should navigate to the list of popular movies list when button is being clicked',
    (WidgetTester tester) async {
      /// stub
      ///
      provideStubProvider(
        tvOnTheAirState: const TvOnTheAirFailure(
          message: 'failed to get data ',
        ),
        tvPopularsState: const TvPopularTvFailure(
          message: 'failed to get data ',
        ),
        tvTopRatedState: const TvTopRatedTvFailure(
          message: 'failed to get data ',
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const TvHomePage(
            onPressAbout: 'onPressAbout',
            onPressWatchlist: 'onPressWatchlist',
            onPressMovies: 'onPressMovie',
          ),
          mockNavigtionObserver,
        ),
      );

      final popularMovieBtn = find.byKey(
        const Key('populars_tv'),
      );

      expect(popularMovieBtn, findsOneWidget);

      final inkWellBtn = find.descendant(
        of: popularMovieBtn,
        matching: find.byType(InkWell),
      );

      await tester.tap(inkWellBtn);
      await tester.pumpAndSettle();

      verify(
        () => mockNavigtionObserver.didPush(evenRoutePopularMovie, any()),
      ).called(1);
    },
  );

  testWidgets(
    'should navigate to the list of top rated list when button is being clicked',
    (WidgetTester tester) async {
      /// stub
      ///
      provideStubProvider(
        tvOnTheAirState: const TvOnTheAirFailure(
          message: 'failed to get data ',
        ),
        tvPopularsState: const TvPopularTvFailure(
          message: 'failed to get data ',
        ),
        tvTopRatedState: const TvTopRatedTvFailure(
          message: 'failed to get data ',
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const TvHomePage(
            onPressAbout: 'onPressAbout',
            onPressWatchlist: 'onPressWatchlist',
            onPressMovies: 'onPressMovie',
          ),
          mockNavigtionObserver,
        ),
      );

      final popularMovies = find.byKey(
        const Key('top_rated_tv'),
      );

      expect(popularMovies, findsOneWidget);

      final inkWellBtn = find.descendant(
        of: popularMovies,
        matching: find.byType(InkWell),
      );

      await tester.tap(inkWellBtn);
      await tester.pumpAndSettle();

      verify(
        () => mockNavigtionObserver.didPush(evenRouteTopRatedMovie, any()),
      ).called(1);
    },
  );

  testWidgets(
    'should navigate to search movies',
    (WidgetTester tester) async {
      /// stub
      ///
      provideStubProvider(
        tvOnTheAirState: const TvOnTheAirFailure(
          message: 'failed to get data ',
        ),
        tvPopularsState: const TvPopularTvFailure(
          message: 'failed to get data ',
        ),
        tvTopRatedState: const TvTopRatedTvFailure(
          message: 'failed to get data ',
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const TvHomePage(
            onPressAbout: 'onPressAbout',
            onPressWatchlist: 'onPressWatchlist',
            onPressMovies: 'onPressMovie',
          ),
          mockNavigtionObserver,
        ),
      );
      final appBar = find.byType(AppBar);

      final searchButton = find.descendant(
        of: appBar,
        matching: find.byType(IconButton),
      );

      expect(searchButton, findsWidgets);

      await tester.tap(searchButton.last);
      await tester.pumpAndSettle();

      verify(
        () => mockNavigtionObserver.didPush(evenRouteSearchMovie, any()),
      ).called(1);
    },
  );
}
