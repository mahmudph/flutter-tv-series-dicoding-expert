import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTopRatedMovieCubit extends MockCubit<TopRatedMoviesState>
    implements TopRatedMoviesCubit {}

class MockPopularMovieCubit extends MockCubit<PopularMovieState>
    implements PopularMovieCubit {}

class MockNowPlayingMovieCubit extends MockCubit<NowPlayingMovieState>
    implements NowPlayingMovieCubit {}

void main() {
  late MockTopRatedMovieCubit mockTopRatedMovieCubit;
  late MockPopularMovieCubit mockPopularMovieCubit;
  late MockNowPlayingMovieCubit mockNowPlayingMovieCubit;

  setUp(() {
    mockTopRatedMovieCubit = MockTopRatedMovieCubit();
    mockPopularMovieCubit = MockPopularMovieCubit();
    mockNowPlayingMovieCubit = MockNowPlayingMovieCubit();
  });

  tearDown(() {
    mockTopRatedMovieCubit.close();
    mockPopularMovieCubit.close();
    mockNowPlayingMovieCubit.close();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TopRatedMoviesCubit>.value(value: mockTopRatedMovieCubit),
        BlocProvider<PopularMovieCubit>.value(value: mockPopularMovieCubit),
        BlocProvider<NowPlayingMovieCubit>.value(
          value: mockNowPlayingMovieCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  void provideStubProvider({
    required TopRatedMoviesState topRatedMoviesState,
    required PopularMovieState popularMovieState,
    required NowPlayingMovieState nowPlayingMovieState,
  }) {
    when(() => mockTopRatedMovieCubit.state).thenReturn(topRatedMoviesState);
    when(() => mockPopularMovieCubit.state).thenReturn(popularMovieState);
    when(() => mockNowPlayingMovieCubit.state).thenReturn(nowPlayingMovieState);

    when(() => mockTopRatedMovieCubit.fetchTopRatedMovies()).thenAnswer(
      (_) async => {},
    );
    when(() => mockPopularMovieCubit.fetchPopularMovies()).thenAnswer(
      (_) async => {},
    );
    when(() => mockNowPlayingMovieCubit.fetchNowPlayingMovie()).thenAnswer(
      (_) async => {},
    );
  }

  Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  testWidgets(
    'should show loading when state home movie page is loading',
    (WidgetTester tester) async {
      /// stub
      provideStubProvider(
        topRatedMoviesState: TopRatedMoviesLoading(),
        popularMovieState: PopularMovieLoading(),
        nowPlayingMovieState: NowPlayingMovieLoading(),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const HomeMoviePage(
            onPressAbout: 'onPressAbout',
            onPressTvs: 'onPressTvs',
            onPressWatchlist: 'onPressWatchlist',
          ),
        ),
      );

      final loading = find.byType(CircularProgressIndicator);

      /// find loading
      final topRatedLoading = findByKey('top_rated_movie_loading');
      final nowPlayingLoading = findByKey('now_playing_movie_loading');
      final popularLoading = findByKey('popular_movie_loading');

      expect(loading, findsNWidgets(3));

      expect(topRatedLoading, findsOneWidget);
      expect(nowPlayingLoading, findsOneWidget);
      expect(popularLoading, findsOneWidget);
    },
  );

  testWidgets(
    'should show movie data when state is success',
    (WidgetTester tester) async {
      /// stub
      provideStubProvider(
        popularMovieState: PopularMovieSucess(movies: testMovieList),
        topRatedMoviesState: TopRatedMoviesSuccess(movies: testMovieList),
        nowPlayingMovieState: NowPlayingMovieSucess(movies: testMovieList),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const HomeMoviePage(
            onPressAbout: 'onPressAbout',
            onPressTvs: 'onPressTvs',
            onPressWatchlist: 'onPressWatchlist',
          ),
        ),
      );

      /// find loading
      final topRatedLoading = findByKey('top_rated_movie_loading');
      final nowPlayingLoading = findByKey('now_playing_movie_loading');
      final popularLoading = findByKey('popular_movie_loading');

      /// list movies data
      final topRatedListMovie = findByKey('top_rated_movie_list');
      final nowPlayingMovie = findByKey('now_playing_movie_list');
      final popularMovie = findByKey('popular_movie_list');

      expect(topRatedLoading, findsNothing);
      expect(nowPlayingLoading, findsNothing);
      expect(popularLoading, findsNothing);

      expect(topRatedListMovie, findsOneWidget);
      expect(nowPlayingMovie, findsOneWidget);
      expect(popularMovie, findsOneWidget);
    },
  );
  testWidgets(
    'should show message error  when state is errror',
    (WidgetTester tester) async {
      /// stub
      ///
      provideStubProvider(
        popularMovieState: const PopularMovieFailure(
          message: "failed to get data movie",
        ),
        topRatedMoviesState: const TopRatedMoviesFailure(
          message: "failed to get data movie",
        ),
        nowPlayingMovieState: const NowPlayingMovieFailure(
          message: "failed to get data movie",
        ),
      );

      await tester.pumpWidget(
        makeTestableWidget(
          const HomeMoviePage(
            onPressAbout: 'onPressAbout',
            onPressTvs: 'onPressTvs',
            onPressWatchlist: 'onPressWatchlist',
          ),
        ),
      );

      /// find loading
      final topRatedLoading = findByKey('top_rated_movie_loading');
      final nowPlayingLoading = findByKey('now_playing_movie_loading');
      final popularLoading = findByKey('popular_movie_loading');

      /// list movies data
      final topRatedListMovie = findByKey('top_rated_movie_list');
      final nowPlayingMovie = findByKey('now_playing_movie_list');
      final popularMovie = findByKey('popular_movie_list');

      expect(topRatedLoading, findsNothing);
      expect(nowPlayingLoading, findsNothing);
      expect(popularLoading, findsNothing);

      expect(topRatedListMovie, findsNothing);
      expect(nowPlayingMovie, findsNothing);
      expect(popularMovie, findsNothing);

      /// errors
      expect(find.text('failed to get data movie'), findsNWidgets(3));
    },
  );
}
