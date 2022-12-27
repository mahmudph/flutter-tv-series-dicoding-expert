import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistCubit extends MockCubit<TvWatchlistState>
    implements TvWatchlistCubit {}

class MockNavigtionObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockWatchlistCubit mockWatchlistCubit;
  late MockNavigtionObserver mockNavigtionObserver;

  setUp(() {
    registerFallbackValue(FakeRoute());
    mockWatchlistCubit = MockWatchlistCubit();
    mockNavigtionObserver = MockNavigtionObserver();
  });

  final eventRoute = MaterialPageRoute(builder: (_) => Container());

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvWatchlistCubit>.value(
      value: mockWatchlistCubit,
      child: MaterialApp(
        navigatorObservers: [mockNavigtionObserver],
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case TvDetailPage.route:
              return eventRoute;
          }
          throw Exception('');
        },
        home: Scaffold(body: body),
      ),
    );
  }

  void stubInitialState() {
    when(() => mockWatchlistCubit.loadTvWatchlist()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should show circular progress indicator when current state is TvWatchlistLoading',
    (tester) async {
      // stub initial state
      stubInitialState();

      when(() => mockWatchlistCubit.state).thenReturn(TvWatchlistLoading());

      await tester.pumpWidget(makeTestableWidget(const TvWatchlistPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);
      var loadingWidget = find.byType(CircularProgressIndicator);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(loadingWidget, findsOneWidget);
    },
  );

  testWidgets(
    'Should show list of the tv when current state is TvTopRatedTvSuccess',
    (tester) async {
      // stub initial state
      stubInitialState();

      when(() => mockWatchlistCubit.state).thenReturn(
        TvWatchlistSuccess(tv: testTvList),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const Scaffold(body: TvWatchlistPage()),
        ),
      );

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsOneWidget);
      expect(listTvWidget, findsAtLeastNWidgets(1));
    },
  );

  testWidgets(
    'Should show error message when state is TvTopRatedTvFailure',
    (tester) async {
      /// stub
      stubInitialState();

      when(() => mockWatchlistCubit.state).thenReturn(
        const TvWatchlistFailure(message: 'no internet connection'),
      );

      await tester.pumpWidget(makeTestableWidget(const TvWatchlistPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('no internet connection'), findsOneWidget);
    },
  );

  testWidgets(
    'Should navigate to the tvDetail page when watchlist is being click',
    (tester) async {
      /// stub
      stubInitialState();

      when(() => mockWatchlistCubit.state).thenReturn(
        TvWatchlistSuccess(tv: testTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const TvWatchlistPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.descendant(
        of: listView,
        matching: find.byType(TvCard),
      );

      expect(listView, findsOneWidget);
      expect(listTvWidget, findsWidgets);

      await tester.tap(listTvWidget.first);
      await tester.pump();

      verify(() => mockNavigtionObserver.didPush(any(), any()));
    },
  );
}
