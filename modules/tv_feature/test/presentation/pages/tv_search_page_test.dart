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

void main() {
  late MockSearchTvCubit mockSearchTvCubit;

  setUp(() {
    mockSearchTvCubit = MockSearchTvCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSearchCubit>.value(
      value: mockSearchTvCubit,
      child: MaterialApp(
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
}
