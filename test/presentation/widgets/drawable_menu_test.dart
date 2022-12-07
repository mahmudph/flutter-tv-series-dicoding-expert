import 'package:ditonton/presentation/widgets/drawable_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
    );
  }

  testWidgets(
    "drawable menu should have correct menu",
    (tester) async {
      var listTile = ["Movies", "Tv Series", "Watchlist", "About"];

      await tester.pumpWidget(_makeTestableWidget(DrawbableMenu()));

      var findListMenu = find.byType(Column);
      var listMenuValue = tester.firstWidget<Column>(findListMenu);

      expect(findListMenu, findsWidgets);
      expect(listMenuValue.children, isNotEmpty);
      expect(listMenuValue.children.length, equals(5));

      var findListMenuItem = find.byType(ListTile);
      var listMenuItemValue = tester.widgetList<ListTile>(findListMenuItem);

      expect(listMenuItemValue.length, equals(listTile.length));

      for (var i = 0; i < listTile.length; i++) {
        expect(listMenuItemValue.elementAt(i).onTap, isNotNull);
        expect(listMenuItemValue.elementAt(i).title, isA<Text>());
        expect(
          listMenuItemValue.elementAt(i).title,
          isA<Text>().having(
            (p0) => p0.data,
            'data',
            equals(listTile[i]),
          ),
        );
      }
    },
  );
}
