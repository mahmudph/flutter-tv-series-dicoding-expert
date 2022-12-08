import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  testWidgets(
    'Should have about information',
    (tester) async {
      await tester.pumpWidget(_makeTestableWidget(AboutPage()));

      var image = find.byType(Image);
      var button = find.byType(IconButton);
      var buttonElement = tester.widget<IconButton>(button);
      var imageElement = tester.widget<Image>(image);

      expect(image, findsOneWidget);
      expect(imageElement.width, equals(128));

      expect(button, findsOneWidget);
      expect(buttonElement.onPressed, isNotNull);

      expect(
        buttonElement.icon,
        isA<Icon>().having(
          (p0) => p0.icon,
          'icon',
          equals(Icons.arrow_back),
        ),
      );
    },
  );
}
