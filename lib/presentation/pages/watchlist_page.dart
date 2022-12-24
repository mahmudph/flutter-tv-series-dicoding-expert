import 'package:flutter/material.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:tv_feature/tv_feature.dart';

class WatchlistPage extends StatefulWidget with RouteAware {
  static const String route = 'watchlist';
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Watchlist",
            style: Theme.of(context).textTheme.headline5,
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.movie),
                key: Key('movie'),
              ),
              Tab(
                icon: Icon(Icons.tv),
                key: Key('tv'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WatchlistMoviesPage(),
            TvWatchlistPage(),
          ],
        ),
      ),
    );
  }
}
