import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// movies keys
  final movieKeys = [
    'now_playing_movie_list',
    'popular_movie_list',
    'top_rated_movie_list',
  ];

  final randomKeys = Random().nextInt(movieKeys.length);

  final randomMovieKey = movieKeys[randomKeys];
  final movieListView = find.byKey(Key(randomMovieKey));

  testWidgets(
    'add then remove movie $randomMovieKey into and from watchlist',
    (WidgetTester tester) async {
      app.main();

      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // find the movie of the top rated or popular or now playing

      await binding.takeScreenshot('movie_home_${randomMovieKey}_page');

      expect(movieListView, findsOneWidget);

      /// find sample of the list top rated movies
      final topRatedMovieFirst = find.descendant(
        of: movieListView,
        matching: find.byType(InkWell),
      );

      expect(topRatedMovieFirst, findsWidgets);

      // tap and then navigate to the movie detail
      await tester.tap(topRatedMovieFirst.first);
      await tester.pumpAndSettle(Duration(seconds: 1));

      await binding.takeScreenshot('movie_detail_${randomMovieKey}_page');

      /// find a button for adding movie into watchlist
      final watchlistBtn = find.byType(ElevatedButton);

      final watchlistBtnIconAdd = find.descendant(
        of: watchlistBtn,
        matching: find.byIcon(Icons.add),
      );

      /// watchlist btn with icon should be exist or showing in the widgets
      ///
      expect(watchlistBtn, findsOneWidget);
      expect(watchlistBtnIconAdd, findsOneWidget);

      await tester.tap(watchlistBtn);
      await tester.pumpAndSettle();

      await binding.takeScreenshot(
        'add_watchlist_$randomMovieKey',
      );

      /// when btn add to watchlist is being click then
      /// icon add should not show then show icons check
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.check), findsOneWidget);

      // rmeove into watchlist
      final watchlistBtnIconRemove = find.descendant(
        of: watchlistBtn,
        matching: find.byIcon(Icons.check),
      );

      expect(watchlistBtnIconRemove, findsOneWidget);

      await tester.tap(watchlistBtnIconRemove);
      await tester.pumpAndSettle();

      /// capture when movie has been remove from watchlist
      await binding.takeScreenshot(
        'remove_watchlist_$randomMovieKey',
      );
      // verify btn icon
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    },
  );
}
