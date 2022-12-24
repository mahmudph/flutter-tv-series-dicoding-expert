import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMovieCubit extends MockCubit<PopularMovieState>
    implements PopularMovieCubit {}

void main() {
  late MockPopularMovieCubit mockPopularMovieCubit;

  setUp(() {
    mockPopularMovieCubit = MockPopularMovieCubit();
  });

  tearDown(() {
    mockPopularMovieCubit.close();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieCubit>.value(
      value: mockPopularMovieCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void stubBlocProvider({
    required PopularMovieState watchlistMovieState,
  }) {
    when(() => mockPopularMovieCubit.state).thenReturn(watchlistMovieState);
    when(() => mockPopularMovieCubit.fetchPopularMovies()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Page should display center progress bar when loading',
    (WidgetTester tester) async {
      /// stub
      stubBlocProvider(watchlistMovieState: PopularMovieLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display ListView when data is loaded',
    (WidgetTester tester) async {
      /// stub
      stubBlocProvider(
        watchlistMovieState: PopularMovieSucess(movies: testMovieList),
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      // stub
      stubBlocProvider(
        watchlistMovieState: const PopularMovieFailure(
          message: 'failed to get popular movie',
        ),
      );

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

      expect(textFinder, findsOneWidget);
    },
  );
}
