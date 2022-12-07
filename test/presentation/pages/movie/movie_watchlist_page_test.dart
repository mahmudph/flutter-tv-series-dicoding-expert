import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieNotifier])
void main() {
  late MockWatchlistMovieNotifier watchlistTvNotifier;

  setUp(() {
    watchlistTvNotifier = MockWatchlistMovieNotifier();
  });

  Widget _setupWidget(Widget body) {
    return MaterialApp(
        home: ChangeNotifierProvider<WatchlistMovieNotifier>.value(
      value: watchlistTvNotifier,
      child: Scaffold(
        body: body,
      ),
    ));
  }

  testWidgets(
    'Should display correct watchlist tv',
    (tester) async {
      when(watchlistTvNotifier.watchlistMovies).thenReturn(testMovieList);
      when(watchlistTvNotifier.watchlistState).thenReturn(RequestState.Loaded);

      await tester.pumpWidget(_setupWidget(WatchlistMoviesPage()));

      var listView = find.byType(ListView);
      var movieCard = find.byType(MovieCard);

      expect(movieCard, findsOneWidget);
      expect(listView, findsOneWidget);
    },
  );

  testWidgets(
    'Should display circular progress indicator when get watchlist is still in progress',
    (tester) async {
      when(watchlistTvNotifier.watchlistMovies).thenReturn(testMovieList);
      when(watchlistTvNotifier.watchlistState).thenReturn(RequestState.Loading);

      await tester.pumpWidget(_setupWidget(WatchlistMoviesPage()));

      var listView = find.byType(CircularProgressIndicator);
      expect(listView, findsOneWidget);
    },
  );

  testWidgets(
    'Should display message error when get watchlist failures',
    (tester) async {
      when(watchlistTvNotifier.watchlistMovies).thenReturn([]);

      when(watchlistTvNotifier.message).thenReturn(
        'failure to get data from local db',
      );
      when(watchlistTvNotifier.watchlistState).thenReturn(RequestState.Error);

      await tester.pumpWidget(_setupWidget(WatchlistMoviesPage()));

      var listView = find.byKey(Key('error_message'));
      var textErorr = find.text('failure to get data from local db');

      expect(listView, findsOneWidget);
      expect(textErorr, findsOneWidget);
    },
  );
}
