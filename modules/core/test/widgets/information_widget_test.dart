import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'should have valid widget',
    (widgetTester) async {
      /// pump widget
      await widgetTester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InformationWidget(
              message: 'no internet connection please try again',
              title: 'process failed',
            ),
          ),
        ),
      );

      /// expect data
      expect(
        find.text('process failed'),
        findsOneWidget,
      );

      expect(
        find.text('no internet connection please try again'),
        findsOneWidget,
      );

      final image = find.byType(Image);
      expect(image, findsOneWidget);
    },
  );
}
