import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/presentation/widgets/tv_seasson_episode.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
    );
  }

  testWidgets(
    "Should tv session data information with correct value",
    (tester) async {
      final completer = Completer<void>();

      await tester.pumpWidget(
        makeTestableWidget(
          TvSeassonEpisode(
            episode: episode,
            onPress: completer.complete,
          ),
        ),
      );

      expect(find.text(episode.name), findsOneWidget);
      final inkWellBtn = find.byType(InkWell);

      expect(inkWellBtn, findsOneWidget);

      await tester.tap(inkWellBtn);
      await tester.pump();

      expect(completer.isCompleted, isTrue);
    },
  );
}
