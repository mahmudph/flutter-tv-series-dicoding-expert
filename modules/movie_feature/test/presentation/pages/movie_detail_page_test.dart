import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailCubit extends MockCubit<MovieDetailState>
    implements MovieDetailCubit {}

class MockWatchlistMovieStatusCubit extends MockCubit<WatchlistMovieStatusState>
    implements WatchlistMovieStatusCubit {}

class MockRecommendationMovieCubit extends MockCubit<RecommendationMoviesState>
    implements RecommendationMoviesCubit {}

void main() {
  late MockMovieDetailCubit mockMovieDetailCubit;
  late MockWatchlistMovieStatusCubit mockWatchlistMovieStatusCubit;
  late MockRecommendationMovieCubit mockRecommendationMovieCubit;

  setUp(() {
    mockMovieDetailCubit = MockMovieDetailCubit();
    mockWatchlistMovieStatusCubit = MockWatchlistMovieStatusCubit();
    mockRecommendationMovieCubit = MockRecommendationMovieCubit();
  });

  const theMovieId = 1;
  final eventRouteDetail = MaterialPageRoute(
    builder: (_) => MovieDetailPage(id: tMovie.id),
    settings: RouteSettings(
      arguments: tMovie.id,
    ),
  );

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailCubit>.value(value: mockMovieDetailCubit),
        BlocProvider<RecommendationMoviesCubit>.value(
          value: mockRecommendationMovieCubit,
        ),
        BlocProvider<WatchlistMovieStatusCubit>.value(
          value: mockWatchlistMovieStatusCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void stubBlocProvider({
    required MovieDetailState movieDetailState,
    required RecommendationMoviesState recommendationMoviesState,
    required WatchlistMovieStatusState watchlistMovieState,
    bool loadWatchlistStatus = true,
  }) {
    /// stub
    when(() => mockMovieDetailCubit.state).thenReturn(movieDetailState);
    when(() => mockRecommendationMovieCubit.state).thenReturn(
      recommendationMoviesState,
    );

    when(() => mockWatchlistMovieStatusCubit.state).thenReturn(
      watchlistMovieState,
    );

    when(() => mockMovieDetailCubit.loadMovieDetail(theMovieId)).thenAnswer(
      (_) async => {},
    );

    when(() =>
            mockRecommendationMovieCubit.fetchRecommendationMovies(theMovieId))
        .thenAnswer(
      (_) async => {},
    );

    when(() => mockWatchlistMovieStatusCubit.loadWatchlistStatus(theMovieId))
        .thenAnswer(
      (_) async => {},
    );
  }

  group(
    'movie detail cubit',
    () {
      testWidgets(
        'Loading CircularProgressIndicator should display when stat movie detail is MovieDetailLoading',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            movieDetailState: MovieDetailLoading(),
            watchlistMovieState: const WatchlistMovieStatusData(),
            recommendationMoviesState: RecommendationMoviesInitial(),
          );

          final circuarProgressIndicator =
              find.byType(CircularProgressIndicator);
          final movieDetailContent = find.byType(DetailContent);
          await tester
              .pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

          expect(circuarProgressIndicator, findsWidgets);
          expect(movieDetailContent, findsNothing);
        },
      );

      testWidgets(
        'DetailContent should dispay when movie detail state is MovieDetailSuccess',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            watchlistMovieState: const WatchlistMovieStatusData(),
            recommendationMoviesState: RecommendationMoviesInitial(),
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
          );

          final circuarProgressIndicator = find.byType(
            CircularProgressIndicator,
          );
          final movieDetailContent = find.byType(DetailContent);
          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(movieDetailContent, findsOneWidget);
          expect(circuarProgressIndicator, findsOneWidget);
        },
      );

      testWidgets(
        'DetailContent should dispay error message when movie detail state is MovieDetailFailure',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            watchlistMovieState: const WatchlistMovieStatusData(),
            recommendationMoviesState: RecommendationMoviesInitial(),
            movieDetailState: const MovieDetailFailure(
              message: 'failed to get data movie detail',
            ),
          );

          final movieDetailContent = find.byType(DetailContent);
          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(movieDetailContent, findsNothing);
          expect(find.text('failed to get data movie detail'), findsOneWidget);
        },
      );
    },
  );

  group(
    'movie recommendations bloc',
    () {
      testWidgets(
        'Should display loading of movie recomendations when state recommendationCubit is RecommendationMoviesLoading',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            watchlistMovieState: const WatchlistMovieStatusData(),
            recommendationMoviesState: RecommendationMoviesLoading(),
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
          );

          final recommendationLists = find.byKey(
            const Key('list_recommendation_movies'),
          );
          final recommendationLoading = find.byKey(
            const Key('loading_recommendation_movies'),
          );
          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(recommendationLists, findsNothing);
          expect(recommendationLoading, findsOneWidget);
        },
      );

      testWidgets(
        'Should display list of movie recomendations when state recommendationCubit is RecommendationMoviesSuccess',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            watchlistMovieState: const WatchlistMovieStatusData(),
            recommendationMoviesState: RecommendationMoviesSuccess(
              movies: testMovieList,
            ),
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
          );

          final recommendationLists = find.byKey(
            const Key('list_recommendation_movies'),
          );
          final recommendationLoading = find.byKey(
            const Key('loading_recommendation_movies'),
          );
          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(recommendationLists, findsOneWidget);
          expect(recommendationLoading, findsNothing);
        },
      );

      testWidgets(
        'Should display message erorr of movie recomendations when state recommendationCubit is RecommendationMoviesFailure',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            watchlistMovieState: const WatchlistMovieStatusData(),
            recommendationMoviesState: const RecommendationMoviesFailure(
              message: 'get recommendation movie errors',
            ),
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
          );

          final recommendationLists = find.byKey(
            const Key('list_recommendation_movies'),
          );

          final recommendationLoading = find.byKey(
            const Key('loading_recommendation_movies'),
          );

          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(recommendationLists, findsNothing);
          expect(recommendationLoading, findsNothing);
          expect(find.text('get recommendation movie errors'), findsOneWidget);
        },
      );
    },
  );

  group(
    'watchlist status cubit',
    () {
      testWidgets(
        'Watchlist button should display add icon when movie not exist in watchlist',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
            watchlistMovieState: const WatchlistMovieStatusData(),
            recommendationMoviesState: RecommendationMoviesSuccess(
              movies: testMovieList,
            ),
          );

          final watchlistButton = find.byType(ElevatedButton);

          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(find.byIcon(Icons.add), findsOneWidget);
          expect(watchlistButton, findsOneWidget);
        },
      );
      testWidgets(
        'Watchlist button should display check icon when movie exist in watchlist',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
            watchlistMovieState: const WatchlistMovieStatusData(
              isAddToWatchlist: true,
            ),
            recommendationMoviesState: RecommendationMoviesSuccess(
              movies: testMovieList,
            ),
          );

          final watchlistButton = find.byType(ElevatedButton);

          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(find.byIcon(Icons.check), findsOneWidget);
          expect(watchlistButton, findsOneWidget);
        },
      );

      testWidgets(
        'should call method addWatchlist when click button add to the watchlist',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
            watchlistMovieState: const WatchlistMovieStatusData(
              isAddToWatchlist: false,
            ),
            recommendationMoviesState: RecommendationMoviesSuccess(
              movies: testMovieList,
            ),
          );

          /// stub addWacthlist
          when(() =>
                  mockWatchlistMovieStatusCubit.addWatchlist(testMovieDetail))
              .thenAnswer(
            (_) async => {},
          );

          final watchlistButton = find.byType(ElevatedButton);

          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(find.byIcon(Icons.add), findsOneWidget);
          expect(watchlistButton, findsOneWidget);

          await tester.tap(watchlistButton);
          await tester.pump();

          verify(
            () => mockWatchlistMovieStatusCubit.addWatchlist(testMovieDetail),
          ).called(1);
        },
      );

      testWidgets(
        'should call method removeFromwachlist when click button add to the watchlist',
        (WidgetTester tester) async {
          /// stub
          stubBlocProvider(
            movieDetailState: const MovieDetailSuccess(
              movieDetail: testMovieDetail,
            ),
            watchlistMovieState: const WatchlistMovieStatusData(
              isAddToWatchlist: true,
            ),
            recommendationMoviesState: RecommendationMoviesSuccess(
              movies: testMovieList,
            ),
          );

          /// stub remove from watchlist
          when(() => mockWatchlistMovieStatusCubit
              .removeFromWatchlist(testMovieDetail)).thenAnswer(
            (_) async => {},
          );

          final watchlistButton = find.byType(ElevatedButton);

          await tester.pumpWidget(
            makeTestableWidget(
              const MovieDetailPage(id: 1),
            ),
          );

          expect(find.byIcon(Icons.check), findsOneWidget);
          expect(watchlistButton, findsOneWidget);

          await tester.tap(watchlistButton);
          await tester.pump();

          verify(
            () => mockWatchlistMovieStatusCubit
                .removeFromWatchlist(testMovieDetail),
          ).called(1);
        },
      );
    },
  );
}
