import 'dart:async';

import 'package:core/widgets/drawable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'should have valid widget drawable',
    (widgetTester) async {
      // create completer
      final onPressAbout = Completer<void>();
      final onPressMovies = Completer<void>();
      final onPressWatchlist = Completer<void>();
      final onPressTvs = Completer<void>();

      await widgetTester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawbableMenu(
              onPressAbout: () => onPressAbout.complete(),
              onPressMovies: () => onPressMovies.complete(),
              onPressWatchlist: () => onPressWatchlist.complete(),
              onPressTvs: () => onPressTvs.complete(),
            ),
          ),
        ),
      );

      ///
      final listTileMenu = find.byType(ListTile);
      expect(listTileMenu, findsNWidgets(4));

      /// movies
      await widgetTester.tap(listTileMenu.at(0));
      await widgetTester.pumpAndSettle();

      expect(onPressMovies.isCompleted, isTrue);

      /// tvs
      await widgetTester.tap(listTileMenu.at(1));
      await widgetTester.pumpAndSettle();

      expect(onPressTvs.isCompleted, isTrue);

      /// watchlist
      await widgetTester.tap(listTileMenu.at(2));
      await widgetTester.pumpAndSettle();

      expect(onPressWatchlist.isCompleted, isTrue);

      /// about
      await widgetTester.tap(listTileMenu.at(3));
      await widgetTester.pumpAndSettle();

      expect(onPressAbout.isCompleted, isTrue);
    },
  );
}
