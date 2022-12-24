import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticService {
  final FirebaseAnalytics firebaseAnalytics;

  FirebaseAnalyticService({
    required this.firebaseAnalytics,
  });

  FirebaseAnalyticsObserver appAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: firebaseAnalytics);
  }
}
