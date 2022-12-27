import 'package:core/commons/constants.dart';
import 'package:flutter/material.dart';

class DrawbableMenu extends StatelessWidget {
  final VoidCallback onPressMovies, onPressTvs;
  final VoidCallback onPressWatchlist, onPressAbout;

  const DrawbableMenu({
    Key? key,
    required this.onPressAbout,
    required this.onPressMovies,
    required this.onPressWatchlist,
    required this.onPressTvs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: kPrussianBlue,
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage('assets/circle-g.png'),
          ),
          accountName: Text('Ditonton Aja'),
          accountEmail: Text('mahmud120398@gmail.com'),
        ),
        ListTile(
          leading: const Icon(Icons.movie),
          title: const Text('Movies'),
          onTap: onPressMovies,
        ),
        ListTile(
          leading: const Icon(Icons.tv),
          title: const Text('Tv Series'),
          onTap: onPressTvs,
        ),
        ListTile(
          leading: const Icon(Icons.save_alt),
          title: const Text('Watchlist'),
          onTap: onPressWatchlist,
        ),
        ListTile(
          onTap: onPressAbout,
          leading: const Icon(Icons.info_outline),
          title: const Text('About'),
        ),
      ],
    );
  }
}
