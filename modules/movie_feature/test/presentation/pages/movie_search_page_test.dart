import 'package:bloc_test/bloc_test.dart';
import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:movie_feature/presentation/widgets/movie_card_list.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchMovies extends MockCubit<SearchMovieState>
    implements SearchMovieCubit {}

void main() {
  late MockSearchMovies searchMovies;

  setUp(() {
    searchMovies = MockSearchMovies();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieCubit>.value(
      value: searchMovies,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const query = 'spidermant';

  void stubBlocProvider({
    required SearchMovieState searchMovieState,
  }) {
    when(() => searchMovies.state).thenReturn(searchMovieState);
    when(() => searchMovies.searchMoviesByQuery(query)).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should display correct search tv results',
    (tester) async {
      // stubs
      stubBlocProvider(
        searchMovieState: SearchMovieSuccess(movies: testMovieList),
      );

      await tester.pumpWidget(makeTestableWidget(const SearchPage()));

      var listView = find.byType(ListView);
      var listViewValue = tester.widget<ListView>(listView);

      var movieCard = find.byType(MovieCard);

      expect(movieCard, findsOneWidget);
      expect(listView, findsOneWidget);

      expect(
        listViewValue.padding,
        isA<EdgeInsetsGeometry>().having(
          (p0) => p0.flipped,
          'padding',
          equals(const EdgeInsets.all(8)),
        ),
      );
    },
  );

  testWidgets(
    'Should display empty data movie when results search movie is empty',
    (tester) async {
      // stubs
      stubBlocProvider(
        searchMovieState: const SearchMovieSuccess(movies: []),
      );

      await tester.pumpWidget(makeTestableWidget(const SearchPage()));

      var listView = find.byType(ListView);
      var movieCard = find.byType(MovieCard);
      var emptyWidget = find.byType(InformationWidget);

      expect(movieCard, findsNothing);
      expect(listView, findsNothing);
      expect(emptyWidget, findsOneWidget);
    },
  );

  testWidgets(
    'Should display loading when search tv is in progress',
    (tester) async {
      stubBlocProvider(
        searchMovieState: SearchMovieLoading(),
      );

      await tester.pumpWidget(makeTestableWidget(const SearchPage()));

      expect(find.byType(MovieCard), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'Should display error when search tv results is failure',
    (tester) async {
      stubBlocProvider(
        searchMovieState: const SearchMovieFailure(message: 'search failure'),
      );
      await tester.pumpWidget(makeTestableWidget(const SearchPage()));

      expect(find.byType(MovieCard), findsNothing);
      expect(find.text('search failure'), findsOneWidget);
    },
  );

  testWidgets(
    'Should call cubit.searchMoviesByQuery(query) when user click search button',
    (tester) async {
      stubBlocProvider(
        searchMovieState: SearchMovieInitial(),
      );

      await tester.pumpWidget(makeTestableWidget(const SearchPage()));

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, query);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      verify(() => searchMovies.searchMoviesByQuery(query)).called(1);
    },
  );
}
