import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/widgets/tv_seasson_episode.dart';
import 'package:tv_feature/tv_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSessionCubit extends MockCubit<TvSessionState>
    implements TvSessionCubit {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route {}

void main() {
  late MockTvSessionCubit mockTvSessionCubit;
  late MockNavigatorObserver mockNavigatorObserver;
  late MaterialPageRoute materialPageRoute;

  setUp(() {
    materialPageRoute = MaterialPageRoute(builder: (_) => Container());
    mockNavigatorObserver = MockNavigatorObserver();
    mockTvSessionCubit = MockTvSessionCubit();
    registerFallbackValue(FakeRoute());
  });

  Widget makeWidget(Widget widget) {
    return BlocProvider<TvSessionCubit>.value(
      value: mockTvSessionCubit,
      child: MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => Container());
            case TvSesionEpisodePage.route:
              return materialPageRoute;
          }
          return null;
        },
        home: widget,
      ),
    );
  }

  const tvId = 1;
  const tvSessionId = 2;

  void provideDependency(
    TvSessionState state,
  ) {
    when(() => mockTvSessionCubit.state).thenReturn(state);
    when(() => mockTvSessionCubit.getTvSessions(tvId, tvSessionId)).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'should call get session data',
    (tester) async {
      /// stub
      provideDependency(TvSessionLoading());

      await tester.pumpWidget(
        makeWidget(
          const TvSessionPage(tvId: tvId, tvSessionId: tvSessionId),
        ),
      );

      verify(
        () => mockTvSessionCubit.getTvSessions(tvId, tvSessionId),
      ).called(1);
    },
  );

  testWidgets(
    'should show circular progress indicator when state is TvSessionLoading',
    (tester) async {
      /// stub
      provideDependency(TvSessionLoading());

      await tester.pumpWidget(
        makeWidget(
          const TvSessionPage(tvId: tvId, tvSessionId: tvSessionId),
        ),
      );

      /// expect
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TvSessionDetail), findsNothing);
    },
  );

  testWidgets(
    'should show widget success when state is ',
    (tester) async {
      /// stub
      provideDependency(const TvSessionSuccess(session: tvSession));

      await tester.pumpWidget(
        makeWidget(
          const TvSessionPage(tvId: tvId, tvSessionId: tvSessionId),
        ),
      );

      /// expect
      expect(find.byType(TvSessionDetail), findsOneWidget);
    },
  );

  testWidgets(
    'should show widget for show message error when there is somting wrong',
    (tester) async {
      /// stub
      provideDependency(
        const TvSessionFailure(message: 'failed to get tv session'),
      );

      await tester.pumpWidget(
        makeWidget(
          const TvSessionPage(tvId: tvId, tvSessionId: tvSessionId),
        ),
      );

      /// expect
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(TvSessionDetail), findsNothing);
      expect(find.text('failed to get tv session'), findsOneWidget);
    },
  );

  testWidgets(
    'should navigate to the tv seasson episode when item episode is clicked',
    (tester) async {
      /// stub
      provideDependency(const TvSessionSuccess(session: tvSession));

      await tester.pumpWidget(
        makeWidget(
          const TvSessionPage(tvId: tvId, tvSessionId: tvSessionId),
        ),
      );

      final tvSessionEpisodeList = find.byType(TvSeassonEpisode);
      expect(tvSessionEpisodeList, findsWidgets);

      await tester.tap(tvSessionEpisodeList.first);
      await tester.pump();

      verify(
        () => mockNavigatorObserver.didPush(materialPageRoute, any()),
      ).called(1);
    },
  );

  testWidgets(
    'should navigate to the tv detail when back button is press',
    (tester) async {
      /// stub
      provideDependency(const TvSessionSuccess(session: tvSession));

      await tester.pumpWidget(
        makeWidget(
          const TvSessionPage(tvId: tvId, tvSessionId: tvSessionId),
        ),
      );

      final tvSessionEpisodeList = find.byType(IconButton);
      expect(tvSessionEpisodeList, findsOneWidget);

      await tester.tap(tvSessionEpisodeList);
      await tester.pump();

      verify(
        () => mockNavigatorObserver.didPop(any(), any()),
      ).called(1);
    },
  );
}
