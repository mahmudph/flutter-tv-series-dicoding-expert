import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// tv keys
  final tvkeys = [
    'on_the_air_tv_list',
    'populars_tv_list',
    'top_rated_tv_list'
  ];

  final randomKeys = Random().nextInt(tvkeys.length);

  final randomTvKey = tvkeys[randomKeys];
  final tvListView = find.byKey(Key(randomTvKey));

  testWidgets(
    'add then remove tv $randomTvKey into and from watchlist',
    (WidgetTester tester) async {
      app.main();

      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      /// find drawer
      final scaffoldState = tester.firstState<ScaffoldState>(
        find.byType(Scaffold),
      );

      /// open drawer
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      /// click menu tv
      final drawerMenu = find.byType(ListTile);
      expect(drawerMenu, findsNWidgets(4));

      await tester.tap(drawerMenu.at(1));
      await tester.pumpAndSettle();

      await binding.takeScreenshot('tvs_home_${randomTvKey}_page');

      expect(tvListView, findsOneWidget);

      /// find sample of the list top rated tvss
      final topRatedtvsFirst = find.descendant(
        of: tvListView,
        matching: find.byType(InkWell),
      );

      expect(topRatedtvsFirst, findsWidgets);

      // tap and then navigate to the tvs detail
      await tester.tap(topRatedtvsFirst.first);
      await tester.pumpAndSettle();

      await binding.takeScreenshot('tvs_detail_${randomTvKey}_page');

      /// find a button for adding tvs into watchlist
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
        'add_watchlist_$randomTvKey',
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

      /// capture when tvs has been remove from watchlist
      await binding.takeScreenshot(
        'remove_watchlist_$randomTvKey',
      );
      // verify btn icon
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.check), findsNothing);
    },
  );
}
