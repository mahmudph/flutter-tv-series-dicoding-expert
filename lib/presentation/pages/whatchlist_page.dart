import 'package:flutter/material.dart';
import 'movie/watchlist_movies_page.dart';
import 'tv/tv_watchlist_page.dart';

class WhatchlistPage extends StatefulWidget with RouteAware {
  static const String route = 'watchlist';
  const WhatchlistPage({Key? key}) : super(key: key);

  @override
  State<WhatchlistPage> createState() => _WhatchlistPageState();
}

class _WhatchlistPageState extends State<WhatchlistPage> {
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
              Tab(icon: Icon(Icons.movie)),
              Tab(icon: Icon(Icons.tv)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Expanded(child: WatchlistMoviesPage()),
            Expanded(child: TvWatchlistPage()),
          ],
        ),
      ),
    );
  }
}
