import 'dart:async';

import 'package:core/widgets/sub_heading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  testWidgets(
    'should have valid widget',
    (testeable) async {
      /// completions
      final completion = Completer<void>();

      /// pump widgets
      await testeable.pumpWidget(
        makeTestableWidget(
          SubheadingWidget(
            onPress: () => completion.complete(),
            title: 'my title',
          ),
        ),
      );

      expect(find.text('my title'), findsOneWidget);

      final onPressDetail = find.byType(InkWell);

      expect(onPressDetail, findsOneWidget);

      await testeable.tap(onPressDetail);
      await testeable.pumpAndSettle();

      expect(completion.isCompleted, isTrue);
    },
  );
}
