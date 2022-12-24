import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedMovieCubit extends MockCubit<TopRatedMoviesState>
    implements TopRatedMoviesCubit {}

void main() {
  late MockTopRatedMovieCubit mockTopRatedCubit;

  setUp(() {
    mockTopRatedCubit = MockTopRatedMovieCubit();
  });

  tearDown(() {
    mockTopRatedCubit.close();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesCubit>.value(
      value: mockTopRatedCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void stubBlocProvider({
    required TopRatedMoviesState topRatedMoviesState,
  }) {
    when(() => mockTopRatedCubit.state).thenReturn(topRatedMoviesState);
    when(() => mockTopRatedCubit.fetchTopRatedMovies()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Page should display progress bar when loading',
    (WidgetTester tester) async {
      /// stub
      stubBlocProvider(topRatedMoviesState: TopRatedMoviesLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display when data is loaded',
    (WidgetTester tester) async {
      /// stub
      stubBlocProvider(
        topRatedMoviesState: TopRatedMoviesSuccess(movies: testMovieList),
      );

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

      expect(listViewFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      /// stub
      ///
      stubBlocProvider(
        topRatedMoviesState: const TopRatedMoviesFailure(
          message: 'failed to get top rated movies',
        ),
      );

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

      expect(textFinder, findsOneWidget);
    },
  );
}
