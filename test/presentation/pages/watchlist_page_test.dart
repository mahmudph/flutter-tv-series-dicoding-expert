import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_watchlist_page.dart';
import 'package:ditonton/presentation/pages/whatchlist_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_page_test.mocks.dart';

@GenerateMocks([
  WatchlistMovieNotifier,
  WatchlistTvNotifier,
])
void main() {
  late MockWatchlistMovieNotifier watchlistMovieNotifier;
  late MockWatchlistTvNotifier watchlistTvNotifier;

  setUp(() {
    watchlistMovieNotifier = MockWatchlistMovieNotifier();
    watchlistTvNotifier = MockWatchlistTvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WatchlistMovieNotifier>.value(
          value: watchlistMovieNotifier,
        ),
        ChangeNotifierProvider<WatchlistTvNotifier>.value(
          value: watchlistTvNotifier,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  testWidgets(
    'Should have tab movie and tv watchlist',
    (tester) async {
      when(watchlistMovieNotifier.watchlistState).thenReturn(
        RequestState.Loaded,
      );
      when(watchlistMovieNotifier.watchlistMovies).thenReturn(
        testMovieList,
      );

      when(watchlistTvNotifier.watchlistState).thenReturn(
        RequestState.Loaded,
      );

      when(watchlistTvNotifier.watchlistTv).thenReturn(
        testTvList,
      );

      await tester.pumpWidget(_makeTestableWidget(WhatchlistPage()));

      var tvWatchlist = find.byType(TvWatchlistPage);
      var movieWatchlist = find.byType(WatchlistMoviesPage);

      expect(tvWatchlist, findsNothing);
      expect(movieWatchlist, findsOneWidget);

      var tabView = find.byType(TabBarView);
      var tabController = DefaultTabController.of(tester.element(tabView));

      expect(tabController?.length, equals(2));
      expect(tabController?.index, 0);
    },
  );
}
