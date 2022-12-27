import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/presentation/pages/tv_session_episode_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSessionEpisodeCubit extends MockCubit<TvSessionEpisodeState>
    implements TvSessionEpisodeCubit {}

void main() {
  const tvId = 1;
  const tvSessionId = 2;
  const tvSessionEpisodeId = 1;
  late MockTvSessionEpisodeCubit mockTvSessionEpisodeCubit;

  setUp(() {
    mockTvSessionEpisodeCubit = MockTvSessionEpisodeCubit();
  });

  Widget makeWidgetTester(Widget child) {
    return BlocProvider<TvSessionEpisodeCubit>.value(
      value: mockTvSessionEpisodeCubit,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  void provideStub(TvSessionEpisodeState state) {
    when(() => mockTvSessionEpisodeCubit.state).thenReturn(state);
    when(
      () => mockTvSessionEpisodeCubit.loadTvSessionEpisode(
        tvId,
        tvSessionId,
        tvSessionEpisodeId,
      ),
    ).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'should show loading indicator',
    (WidgetTester tester) async {
      /// stub
      provideStub(TvSessionEpisodeLoading());

      /// pump widgets
      await tester.pumpWidget(
        makeWidgetTester(
          const TvSesionEpisodePage(
            tvId: tvId,
            tvSessionId: tvSessionId,
            tvSessionEpisodeId: tvSessionEpisodeId,
          ),
        ),
      );

      /// verify
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(TvSessionEpisodeDetail), findsNothing);
    },
  );

  testWidgets(
    'should show TvSessionEpisodeDetail when get episode success',
    (WidgetTester tester) async {
      /// stub
      provideStub(const TvSessionEpisodeSuccess(episode: episode));

      /// pump widgets
      await tester.pumpWidget(
        makeWidgetTester(
          const TvSesionEpisodePage(
            tvId: tvId,
            tvSessionId: tvSessionId,
            tvSessionEpisodeId: tvSessionEpisodeId,
          ),
        ),
      );

      /// verify
      expect(find.byType(TvSessionEpisodeDetail), findsOneWidget);
    },
  );

  testWidgets(
    'should show message error when get episode failure',
    (WidgetTester tester) async {
      /// stub
      provideStub(
        const TvSessionEpisodeFailure(message: 'failed to get episode'),
      );

      /// pump widgets
      await tester.pumpWidget(
        makeWidgetTester(
          const TvSesionEpisodePage(
            tvId: tvId,
            tvSessionId: tvSessionId,
            tvSessionEpisodeId: tvSessionEpisodeId,
          ),
        ),
      );

      /// verify
      expect(find.text('failed to get episode'), findsOneWidget);
    },
  );
}
