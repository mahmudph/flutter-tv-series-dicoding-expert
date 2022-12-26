import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchTvCubit extends MockCubit<TvSearchState>
    implements TvSearchCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockSearchTvCubit mockSearchTvCubit;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    registerFallbackValue(FakeRoute());
    mockSearchTvCubit = MockSearchTvCubit();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  final eventRoute = MaterialPageRoute(builder: (_) => Container());

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSearchCubit>.value(
      value: mockSearchTvCubit,
      child: MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case TvDetailPage.route:
              return eventRoute;
          }
          return null;
        },
        home: body,
      ),
    );
  }

  const searchQuery = 'spidermant';

  void stubInitialState() {
    when(() => mockSearchTvCubit.searchTvByQuery(searchQuery)).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should show circular progress indicator when current state is TvSearchLoading',
    (tester) async {
      // stub initial state
      stubInitialState();

      when(() => mockSearchTvCubit.state).thenReturn(TvSearchLoading());

      await tester.pumpWidget(makeTestableWidget(const TvSearchPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);
      var loadingWidget = find.byType(CircularProgressIndicator);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(loadingWidget, findsOneWidget);
    },
  );

  testWidgets(
    'Should show list of the tv when current state is TvOnTheAirSuccess',
    (tester) async {
      // stub initial state
      stubInitialState();

      when(() => mockSearchTvCubit.state).thenReturn(
        TvSearchSuccess(tv: testTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const TvSearchPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsOneWidget);
      expect(listTvWidget, findsAtLeastNWidgets(1));
    },
  );

  testWidgets(
    'Should show error message when state is TvSearchFailure',
    (tester) async {
      /// stub
      stubInitialState();

      when(() => mockSearchTvCubit.state).thenReturn(
        const TvSearchFailure(message: 'no internet connection'),
      );

      await tester.pumpWidget(makeTestableWidget(const TvSearchPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('no internet connection'), findsOneWidget);
    },
  );

  testWidgets(
    'Shoud call searchTvByQuery when text input action is click and entered',
    (tester) async {
      /// stub
      stubInitialState();

      when(() => mockSearchTvCubit.state).thenReturn(
        TvSearchSuccess(tv: testTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const TvSearchPage()));

      final textField = find.byType(TextField);

      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'spidermant');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      verify(() => mockSearchTvCubit.searchTvByQuery('spidermant')).called(1);
    },
  );

  testWidgets(
    'Shoud call push to the new screen when when TvCard being clicked',
    (tester) async {
      /// stub
      stubInitialState();

      when(() => mockSearchTvCubit.state).thenReturn(
        TvSearchSuccess(tv: testTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const TvSearchPage()));

      final textField = find.byType(TvCard);

      expect(textField, findsOneWidget);

      await tester.tap(textField);
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(eventRoute, any()));
    },
  );

  testWidgets(
    'should show empty widget when search state is initial or else ',
    (tester) async {
      /// stub
      stubInitialState();
      when(() => mockSearchTvCubit.state).thenReturn(TvSearchInitial());

      await tester.pumpWidget(makeTestableWidget(const TvSearchPage()));
      expect(find.byType(Expanded), findsOneWidget);
    },
  );
}
