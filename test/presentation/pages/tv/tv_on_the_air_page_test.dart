import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv/tv_on_the_air_page.dart';
import 'package:ditonton/presentation/provider/tv_on_the_air_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_on_the_air_page_test.mocks.dart';

@GenerateMocks([TvOnTheAirNotifier])
void main() {
  late MockTvOnTheAirNotifier mockTvOnTheAirNotifier;

  setUp(() {
    mockTvOnTheAirNotifier = MockTvOnTheAirNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvOnTheAirNotifier>.value(
      value: mockTvOnTheAirNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'Should show on the air show with correct data',
    (tester) async {
      when(mockTvOnTheAirNotifier.state).thenReturn(RequestState.Loaded);
      when(mockTvOnTheAirNotifier.tvs).thenReturn(testTvList);

      await tester.pumpWidget(_makeTestableWidget(TvOnTheAirPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsOneWidget);
      expect(listTvWidget, findsOneWidget);
    },
  );

  testWidgets(
    'Should show error message the air show with when failure to get data from server',
    (tester) async {
      when(mockTvOnTheAirNotifier.state).thenReturn(RequestState.Error);
      when(mockTvOnTheAirNotifier.message).thenReturn('failure');
      when(mockTvOnTheAirNotifier.tvs).thenReturn([]);

      await tester.pumpWidget(_makeTestableWidget(TvOnTheAirPage()));

      var listView = find.byType(ListView);
      var listTvWidget = find.byType(TvCard);

      expect(listView, findsNothing);
      expect(listTvWidget, findsNothing);
      expect(find.byKey(Key('error_message')), findsOneWidget);
      expect(find.text('failure'), findsOneWidget);
    },
  );
}
