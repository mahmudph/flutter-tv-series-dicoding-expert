import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:tv_feature/tv_feature.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeMoviePage.route:
      return MaterialPageRoute(
        builder: (_) => HomeMoviePage(
          onPressAbout: AboutPage.route,
          onPressTvs: TvHomePage.route,
          onPressWatchlist: WatchlistPage.route,
        ),
      );
    case PopularMoviesPage.route:
      return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
    case TopRatedMoviesPage.route:
      return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
    case MovieDetailPage.route:
      final id = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => MovieDetailPage(id: id),
        settings: settings,
      );
    case SearchPage.route:
      return CupertinoPageRoute(builder: (_) => SearchPage());
    case AboutPage.route:
      return MaterialPageRoute(builder: (_) => AboutPage());
    case TvHomePage.route:
      return MaterialPageRoute(
        builder: (_) => TvHomePage(
          onPressAbout: AboutPage.route,
          onPressMovies: HomeMoviePage.route,
          onPressWatchlist: WatchlistPage.route,
        ),
      );
    case WatchlistPage.route:
      return MaterialPageRoute(builder: (_) => WatchlistPage());
    case TvDetailPage.route:
      final id = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => TvDetailPage(id: id));
    case TvPopularsPage.route:
      return MaterialPageRoute(builder: (_) => TvPopularsPage());
    case TvTopRatedPage.route:
      return MaterialPageRoute(builder: (_) => TvTopRatedPage());
    case TvSearchPage.route:
      return MaterialPageRoute(builder: (_) => TvSearchPage());
    case TvOnTheAirPage.route:
      return MaterialPageRoute(builder: (_) => TvOnTheAirPage());
    default:
      return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('Page not found :('),
            ),
          );
        },
      );
  }
}
