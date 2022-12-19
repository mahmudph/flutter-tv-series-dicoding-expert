import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/presentation/widgets/tv_list.dart';

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
      await tester.pumpWidget(makeTestableWidget(TvList(testTvList)));

      var listView = find.byType(ListView);
      var cachedImageTv = find.byType(CachedNetworkImage);
      var cachedImageTvValue = tester.widget<CachedNetworkImage>(cachedImageTv);

      expect(listView, findsOneWidget);
      expect(cachedImageTv, findsOneWidget);
      expect(
        cachedImageTvValue.errorWidget,
        isNotNull,
      );
    },
  );
}
