import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:tv_feature/tv_feature.dart';

class MockWatchlistMovieCubit extends MockCubit<WatchlistMovieState>
    implements WatchlistMovieCubit {}

class MockWatchlistTvCubit extends MockCubit<TvWatchlistState>
    implements TvWatchlistCubit {}

void main() {
  late MockWatchlistMovieCubit mockWatchlistMovieCubit;
  late MockWatchlistTvCubit mockWatchlistTvCubit;

  setUp(() {
    mockWatchlistMovieCubit = MockWatchlistMovieCubit();
    mockWatchlistTvCubit = MockWatchlistTvCubit();
  });

  final testTv = Tv(
    backdropPath: 'backdropPath',
    firstAirDate: "2021-05-23",
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final testMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final testMovieList = [testMovie];
  final testTvList = [testTv];

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMovieCubit>.value(value: mockWatchlistMovieCubit),
        BlocProvider<TvWatchlistCubit>.value(value: mockWatchlistTvCubit),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void provideStubProvider({
    required WatchlistMovieState watchlistMovieState,
    required TvWatchlistState tvWatchlistState,
  }) {
    when(() => mockWatchlistMovieCubit.state).thenReturn(watchlistMovieState);
    when(() => mockWatchlistTvCubit.state).thenReturn(tvWatchlistState);

    when(() => mockWatchlistMovieCubit.loadMovieWatchlist()).thenAnswer(
      (_) async => {},
    );

    when(() => mockWatchlistTvCubit.loadTvWatchlist()).thenAnswer(
      (_) async => {},
    );
  }

  testWidgets(
    'Should have tab movie and tv watchlist',
    (tester) async {
      /// stub widget
      provideStubProvider(
        watchlistMovieState: WatchlistMovieDataSuccess(movies: testMovieList),
        tvWatchlistState: TvWatchlistSuccess(tv: testTvList),
      );

      /// pump widget
      await tester.pumpWidget(_makeTestableWidget(WatchlistPage()));

      var tvWatchlist = find.byType(TvWatchlistPage);
      var movieWatchlist = find.byType(WatchlistMoviesPage);

      expect(tvWatchlist, findsNothing);
      expect(movieWatchlist, findsOneWidget);

      var tabView = find.byType(TabBarView);
      var tabController = DefaultTabController.of(tester.element(tabView));

      expect(tabController?.length, equals(2));
      expect(tabController?.index, 0);
    },
  );
}
