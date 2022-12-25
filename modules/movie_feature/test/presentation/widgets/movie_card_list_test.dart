import 'package:core/commons/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/presentation/pages/movie_detail_page.dart';
import 'package:movie_feature/presentation/widgets/movie_card_list.dart';

import '../../dummy_data/dummy_objects.dart';

class MockNvigationObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MaterialPageRoute materialPageRoute;
  late MockNvigationObserver mockNvigationObserver;

  setUp(() {
    mockNvigationObserver = MockNvigationObserver();
    materialPageRoute = MaterialPageRoute(builder: (_) => Container());
    registerFallbackValue(FakeRoute());
  });

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      navigatorObservers: [mockNvigationObserver],
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case MovieDetailPage.route:
            return materialPageRoute;
        }
        return null;
      },
      home: Scaffold(body: body),
    );
  }

  testWidgets(
    "Should display movie information with correct data or value",
    (tester) async {
      await tester.pumpWidget(makeTestableWidget(const MovieCard(testMovie)));

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
          '$baseUrlImage${testMovie.posterPath}',
        ),
      );
    },
  );

  testWidgets(
    "Should navigate to the movie detail when inkwell button being press",
    (tester) async {
      await tester.pumpWidget(makeTestableWidget(const MovieCard(testMovie)));

      var cardGestureRecognizer = find.byType(InkWell);

      expect(cardGestureRecognizer, findsOneWidget);

      var inkwellData = tester.widget<InkWell>(cardGestureRecognizer);
      expect(inkwellData.onTap, isNotNull);

      await tester.tap(cardGestureRecognizer);
      await tester.pumpAndSettle();

      verify(
        () => mockNvigationObserver.didPush(materialPageRoute, any()),
      ).called(1);
    },
  );
}
