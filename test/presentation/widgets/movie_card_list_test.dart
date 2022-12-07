import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
    );
  }

  testWidgets(
    "Should display movie information with correct data or value",
    (tester) async {
      await tester.pumpWidget(_makeTestableWidget(MovieCard(testMovie)));

      var cardGestureRecognizer = find.byType(InkWell);
      var cachedImageTv = find.byType(CachedNetworkImage);
      var cachedImageTvValue = tester.widget<CachedNetworkImage>(cachedImageTv);

      var inkwellData = tester.widget<InkWell>(cardGestureRecognizer);
      expect(inkwellData.onTap, isNotNull);

      expect(cardGestureRecognizer, findsOneWidget);
      expect(find.text(testMovie.title!), findsOneWidget);
      expect(find.text(testMovie.overview!), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(cachedImageTv, findsOneWidget);

      expect(cachedImageTvValue.width, equals(80));

      expect(
        cachedImageTvValue.imageUrl,
        equals(
          '$BASE_IMAGE_URL${testMovie.posterPath}',
        ),
      );
    },
  );
}
