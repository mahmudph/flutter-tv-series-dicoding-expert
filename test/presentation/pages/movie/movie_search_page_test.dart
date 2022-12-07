import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_search_page_test.mocks.dart';

@GenerateMocks([MovieSearchNotifier])
void main() {
  late MockMovieSearchNotifier mockTvSearchNotifier;

  setUp(() {
    mockTvSearchNotifier = MockMovieSearchNotifier();
  });

  Widget _setupWidget(Widget body) {
    return MaterialApp(
      home: ChangeNotifierProvider<MovieSearchNotifier>.value(
        value: mockTvSearchNotifier,
        child: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets(
    'Should display correct search tv results',
    (tester) async {
      when(mockTvSearchNotifier.searchResult).thenReturn(testMovieList);
      when(mockTvSearchNotifier.state).thenReturn(RequestState.Loaded);

      await tester.pumpWidget(_setupWidget(SearchPage()));

      var listView = find.byType(ListView);
      var listViewValue = tester.widget<ListView>(listView);

      var movieCard = find.byType(MovieCard);

      expect(movieCard, findsOneWidget);
      expect(listView, findsOneWidget);
      expect(
        listViewValue.padding,
        isA<EdgeInsetsGeometry>().having(
          (p0) => p0.flipped,
          'padding',
          equals(EdgeInsets.all(8)),
        ),
      );
    },
  );

  testWidgets(
    'Should display loading when search tv is in progress',
    (tester) async {
      when(mockTvSearchNotifier.searchResult).thenReturn([]);
      when(mockTvSearchNotifier.state).thenReturn(RequestState.Loading);

      await tester.pumpWidget(_setupWidget(SearchPage()));

      expect(find.byType(TvCard), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should display error when search tv results is failure',
    (tester) async {
      when(mockTvSearchNotifier.searchResult).thenReturn([]);
      when(mockTvSearchNotifier.state).thenReturn(RequestState.Error);
      when(mockTvSearchNotifier.message).thenReturn('process failure');

      await tester.pumpWidget(_setupWidget(SearchPage()));

      expect(find.byType(TvCard), findsNothing);
      expect(find.text('process failure'), findsOneWidget);
    },
  );
}
