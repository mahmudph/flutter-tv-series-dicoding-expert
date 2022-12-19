import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvPopularCubit extends MockCubit<TvPopularsState>
    implements TvPopularsCubit {}

void main() {
  late MockTvPopularCubit mockTvPopularCubit;

  setUp(() {
    mockTvPopularCubit = MockTvPopularCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvPopularsCubit>.value(
      value: mockTvPopularCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void stubInitialState() {
    when(() => mockTvPopularCubit.fetchPopulartv()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should show circular progress indicator when current state is TvPopularTvLoading',
    (tester) async {
      // stub initial state
      stubInitialState();

      when(() => mockTvPopularCubit.state).thenReturn(TvPopularTvLoading());

      await tester.pumpWidget(makeTestableWidget(const TvPopularsPage()));

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

      when(() => mockTvPopularCubit.state).thenReturn(
        TvPopularTvSuccess(listPopularTvTv: testTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const TvPopularsPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsOneWidget);
      expect(listTvWidget, findsAtLeastNWidgets(1));
    },
  );

  testWidgets(
    'Should show error message when state is TvPopularTvFailure',
    (tester) async {
      /// stub
      stubInitialState();

      when(() => mockTvPopularCubit.state).thenReturn(
        const TvPopularTvFailure(message: 'no internet connection'),
      );

      await tester.pumpWidget(makeTestableWidget(const TvPopularsPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('no internet connection'), findsOneWidget);
    },
  );
}
