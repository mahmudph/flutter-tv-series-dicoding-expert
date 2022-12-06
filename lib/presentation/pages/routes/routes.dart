import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_home_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_populars_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_search_page.dart';
import 'package:ditonton/presentation/pages/tv/tv_top_rated_page.dart';
import 'package:ditonton/presentation/pages/whatchlist_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movie/search_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/home':
      return MaterialPageRoute(builder: (_) => HomeMoviePage());
    case PopularMoviesPage.ROUTE_NAME:
      return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
    case TopRatedMoviesPage.ROUTE_NAME:
      return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
    case MovieDetailPage.ROUTE_NAME:
      final id = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => MovieDetailPage(id: id),
        settings: settings,
      );
    case SearchPage.ROUTE_NAME:
      return CupertinoPageRoute(builder: (_) => SearchPage());
    case AboutPage.ROUTE_NAME:
      return MaterialPageRoute(builder: (_) => AboutPage());
    case HomeMoviePage.route:
      return MaterialPageRoute(builder: (_) => HomeMoviePage());
    case TvHomePage.route:
      return MaterialPageRoute(builder: (_) => TvHomePage());
    case WhatchlistPage.route:
      return MaterialPageRoute(builder: (_) => WhatchlistPage());
    case TvDetailPage.ROUTE_NAME:
      final id = settings.arguments as int;
      return MaterialPageRoute(builder: (_) => TvDetailPage(id: id));
    case TvPopularsPage.ROUTE_NAME:
      return MaterialPageRoute(builder: (_) => TvPopularsPage());
    case TvTopRatedPage.ROUTE_NAME:
      return MaterialPageRoute(builder: (_) => TvTopRatedPage());
    case TvSearchPage.ROUTE_NAME:
      return MaterialPageRoute(builder: (_) => TvSearchPage());
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
