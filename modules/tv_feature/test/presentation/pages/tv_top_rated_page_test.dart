import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvTopRatedCubit extends MockCubit<TvTopRatedState>
    implements TvTopRatedCubit {}

void main() {
  late MockTvTopRatedCubit mockTvTopRatedCubit;

  setUp(() {
    mockTvTopRatedCubit = MockTvTopRatedCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvTopRatedCubit>.value(
      value: mockTvTopRatedCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void stubInitialState() {
    when(() => mockTvTopRatedCubit.fetchTopRatedTv()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should show circular progress indicator when current state is TvTopRatedTvLoading',
    (tester) async {
      // stub initial state
      stubInitialState();

      when(() => mockTvTopRatedCubit.state).thenReturn(TvTopRatedTvLoading());

      await tester.pumpWidget(makeTestableWidget(const TvTopRatedPage()));

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

      when(() => mockTvTopRatedCubit.state).thenReturn(
        TvTopRatedTvSuccess(listTopRatedTv: testTvList),
      );

      await tester.pumpWidget(makeTestableWidget(const TvTopRatedPage()));

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

      when(() => mockTvTopRatedCubit.state).thenReturn(
        const TvTopRatedTvFailure(message: 'no internet connection'),
      );

      await tester.pumpWidget(makeTestableWidget(const TvTopRatedPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('no internet connection'), findsOneWidget);
    },
  );
}
