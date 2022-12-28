import 'dart:async';
import 'package:core/core.dart';
import 'package:ditonton/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:ditonton/presentation/pages/routes/routes.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:tv_feature/presentation/bloc/tv_details/tv_details_cubit.dart';
import 'package:tv_feature/tv_feature.dart';

import 'presentation/pages/splashscreen_page.dart';

void main() async {
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// initialize firebase app
      await Firebase.initializeApp();

      /// initialize env
      await dotenv.load(fileName: ".env");

      /// initialize di
      di.init(await globalContext);

      runApp(MyApp());
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TvDetailsCubit>.value(
          value: di.locator<TvDetailsCubit>(),
        ),
        BlocProvider<TvOnTheAirCubit>.value(
          value: di.locator<TvOnTheAirCubit>(),
        ),
        BlocProvider<TvPopularsCubit>.value(
          value: di.locator<TvPopularsCubit>(),
        ),
        BlocProvider<TvRecomendationsCubit>.value(
          value: di.locator<TvRecomendationsCubit>(),
        ),
        BlocProvider<TvSearchCubit>.value(
          value: di.locator<TvSearchCubit>(),
        ),
        BlocProvider<TvTopRatedCubit>.value(
          value: di.locator<TvTopRatedCubit>(),
        ),
        BlocProvider<TvWatchlistCubit>.value(
          value: di.locator<TvWatchlistCubit>(),
        ),
        BlocProvider<TvWatchlistStatusCubit>.value(
          value: di.locator<TvWatchlistStatusCubit>(),
        ),
        BlocProvider<MovieDetailCubit>.value(
          value: di.locator<MovieDetailCubit>(),
        ),
        BlocProvider<NowPlayingMovieCubit>.value(
          value: di.locator<NowPlayingMovieCubit>(),
        ),
        BlocProvider<PopularMovieCubit>.value(
          value: di.locator<PopularMovieCubit>(),
        ),
        BlocProvider<RecommendationMoviesCubit>.value(
          value: di.locator<RecommendationMoviesCubit>(),
        ),
        BlocProvider<SearchMovieCubit>.value(
          value: di.locator<SearchMovieCubit>(),
        ),
        BlocProvider<TopRatedMoviesCubit>.value(
          value: di.locator<TopRatedMoviesCubit>(),
        ),
        BlocProvider<WatchlistMovieCubit>.value(
          value: di.locator<WatchlistMovieCubit>(),
        ),
        BlocProvider<WatchlistMovieStatusCubit>.value(
          value: di.locator<WatchlistMovieStatusCubit>(),
        ),
        BlocProvider<TvSessionCubit>.value(
          value: di.locator<TvSessionCubit>(),
        ),
        BlocProvider<TvSessionEpisodeCubit>.value(
          value: di.locator<TvSessionEpisodeCubit>(),
        )
      ],
      child: MaterialApp(
        navigatorObservers: [
          routeObserver,
          locator<FirebaseAnalyticService>().appAnalyticsObserver(),
        ],
        onGenerateRoute: generateRoute,
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: SplashscreenPage(),
      ),
    );
  }
}
