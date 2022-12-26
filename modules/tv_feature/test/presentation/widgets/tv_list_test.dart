import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/pages/tv_detail_page.dart';
import 'package:tv_feature/presentation/widgets/tv_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../dummy_data/dummy_objects.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockNavigationObserver mockNavigationObserver;

  setUp(() {
    mockNavigationObserver = MockNavigationObserver();
    registerFallbackValue(FakeRoute());
  });

  final eventRoute = MaterialPageRoute(builder: (_) => Container());

  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      navigatorObservers: [mockNavigationObserver],
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case TvDetailPage.route:
            return eventRoute;
        }
        return null;
      },
      home: Scaffold(body: body),
    );
  }

  testWidgets(
    "Should tv session data information with correct value",
    (tester) async {
      /// pump widgets
      ///
      await tester.pumpWidget(
        makeTestableWidget(
          TvList(
            tvs: testTvList,
          ),
        ),
      );

      var listView = find.byType(ListView);
      var cachedImageTv = find.byType(CachedNetworkImage);
      var cachedImageTvValue = tester.widget<CachedNetworkImage>(cachedImageTv);

      expect(listView, findsOneWidget);

      expect(cachedImageTv, findsOneWidget);

      expect(
        cachedImageTvValue.errorWidget,
        isNotNull,
      );

      final inkWell = find.descendant(
        of: listView,
        matching: find.byType(InkWell),
      );

      expect(inkWell, findsOneWidget);

      await tester.tap(inkWell.first);
      await tester.pumpAndSettle();

      verify(
        () => mockNavigationObserver.didPush(eventRoute, any()),
      ).called(1);
    },
  );
}
