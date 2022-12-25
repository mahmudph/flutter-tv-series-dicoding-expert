import 'package:core/utils/firebase_analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

void main() {
  late MockFirebaseAnalytics mockFirebaseAnalytics;
  late FirebaseAnalyticService firebaseAnalyticService;

  setUp(() {
    mockFirebaseAnalytics = MockFirebaseAnalytics();
    firebaseAnalyticService = FirebaseAnalyticService(
      firebaseAnalytics: mockFirebaseAnalytics,
    );
  });

  test(
    'appAnalyticsObserver',
    () {
      final result = firebaseAnalyticService.appAnalyticsObserver();
      expect(result.analytics, isA<MockFirebaseAnalytics>());
    },
  );
}
