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

void main() {
  late MockWatchlistCubit mockWatchlistCubit;

  setUp(() {
    mockWatchlistCubit = MockWatchlistCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvWatchlistCubit>.value(
      value: mockWatchlistCubit,
      child: MaterialApp(
        home: body,
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
}
