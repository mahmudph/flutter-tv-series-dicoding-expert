import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:movie_feature/presentation/widgets/movie_card_list.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieWatchlist extends MockCubit<WatchlistMovieState>
    implements WatchlistMovieCubit {}

void main() {
  late MockMovieWatchlist mockWatchlistCubit;

  setUp(() {
    mockWatchlistCubit = MockMovieWatchlist();
  });

  tearDown(() {
    mockWatchlistCubit.close();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieCubit>.value(
      value: mockWatchlistCubit,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  void stubBlocProvider({
    required WatchlistMovieState watchlistMovieState,
  }) {
    when(() => mockWatchlistCubit.state).thenReturn(watchlistMovieState);
    when(() => mockWatchlistCubit.loadMovieWatchlist()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should display correct watchlist tv',
    (tester) async {
      /// stub
      stubBlocProvider(
        watchlistMovieState: WatchlistMovieDataSuccess(movies: testMovieList),
      );

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      var listView = find.byType(ListView);
      var movieCard = find.byType(MovieCard);
      // var loading = find.byType(CircularProgressIndicator);

      // spy
      verify(() => mockWatchlistCubit.loadMovieWatchlist()).called(1);

      /// epected
      expect(movieCard, findsWidgets);
      expect(listView, findsOneWidget);
      // expect(loading, findsNothing);
    },
  );

  testWidgets(
    'Should display circular progress indicator when get watchlist is still in progress',
    (tester) async {
      /// stub
      stubBlocProvider(watchlistMovieState: WatchlistMovieLoading());
      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      var listView = find.byType(ListView);
      var movieCard = find.byType(MovieCard);
      var loading = find.byType(CircularProgressIndicator);

      verify(() => mockWatchlistCubit.loadMovieWatchlist()).called(1);

      expect(listView, findsNothing);
      expect(movieCard, findsNothing);
      expect(loading, findsOneWidget);
    },
  );

  testWidgets(
    'Should display message error when get watchlist failures',
    (tester) async {
      // stub
      stubBlocProvider(
        watchlistMovieState: const WatchlistMovieFailure(
          message: 'failed to get data watchlist movie',
        ),
      );

      await tester.pumpWidget(makeTestableWidget(const WatchlistMoviesPage()));

      var listView = find.byKey(const Key('error_message'));
      var textErorr = find.text('failed to get data watchlist movie');

      expect(listView, findsOneWidget);
      expect(textErorr, findsOneWidget);
    },
  );
}
