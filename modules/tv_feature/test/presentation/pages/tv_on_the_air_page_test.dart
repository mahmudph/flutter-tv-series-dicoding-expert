import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/bloc/tv_on_the_air/tv_on_the_air_cubit.dart';
import 'package:tv_feature/presentation/pages/tv_on_the_air_page.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvOnTheAirCubit extends MockCubit<TvOnTheAirState>
    implements TvOnTheAirCubit {}

void main() {
  late MockTvOnTheAirCubit mockTvOnTheAirCubit;

  setUp(() {
    mockTvOnTheAirCubit = MockTvOnTheAirCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvOnTheAirCubit>.value(
      value: mockTvOnTheAirCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void stubInitialState() {
    when(() => mockTvOnTheAirCubit.fetchOnTheAirTvs()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should show circular progress indicator when current state is TvOnTheAirLoading',
    (tester) async {
      // stub initial state
      stubInitialState();

      when(() => mockTvOnTheAirCubit.state).thenReturn(TvOnTheAirLoading());

      await tester.pumpWidget(makeTestableWidget(const TvOnTheAirPage()));

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

      when(() => mockTvOnTheAirCubit.state).thenReturn(
        TvOnTheAirSuccess(listOnTheAirTv: testTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const TvOnTheAirPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsOneWidget);
      expect(listTvWidget, findsAtLeastNWidgets(1));
    },
  );

  testWidgets(
    'Should show error message the air show with when failure to get data from server',
    (tester) async {
      /// stub
      stubInitialState();

      when(() => mockTvOnTheAirCubit.state).thenReturn(
        const TvOnTheAirFailure(message: 'no internet connection'),
      );

      await tester.pumpWidget(makeTestableWidget(const TvOnTheAirPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('no internet connection'), findsOneWidget);
    },
  );
}
