import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/widgets/drawable_menu.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/presentation/widgets/tv_list.dart';

import 'tv_on_the_air_page.dart';
import 'tv_populars_page.dart';
import 'tv_search_page.dart';
import 'tv_top_rated_page.dart';

class TvHomePage extends StatefulWidget {
  static const String route = "tv/home";

  final VoidCallback onPressWatchlist, onPressAbout, onPressMovies;

  const TvHomePage({
    super.key,
    required this.onPressAbout,
    required this.onPressWatchlist,
    required this.onPressMovies,
  });
  @override
  State<TvHomePage> createState() => _TvHomePageState();
}

class _TvHomePageState extends State<TvHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TvPopularsCubit>(context, listen: false).fetchPopulartv();
      BlocProvider.of<TvTopRatedCubit>(context, listen: false)
          .fetchTopRatedTv();
      BlocProvider.of<TvOnTheAirCubit>(context, listen: false)
          .fetchOnTheAirTvs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawbableMenu(
          onPressMovies: widget.onPressMovies,
          onPressAbout: widget.onPressWatchlist,
          onPressWatchlist: widget.onPressWatchlist,
          onPressTvs: () => Navigator.pushNamed(
            context,
            TvHomePage.route,
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TvSearchPage.route);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'On The Air',
                onTap: () => Navigator.pushNamed(context, TvOnTheAirPage.route),
              ),
              BlocBuilder<TvOnTheAirCubit, TvOnTheAirState>(
                bloc: context.read<TvOnTheAirCubit>(),
                builder: (context, state) {
                  if (state is TvOnTheAirLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvOnTheAirSuccess) {
                    return TvList(state.listOnTheAirTv);
                  } else if (state is TvOnTheAirFailure) {
                    return Text(state.message);
                  }
                  return const Text("Failed");
                },
              ),
              _buildSubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(context, TvPopularsPage.route),
              ),
              BlocBuilder<TvPopularsCubit, TvPopularsState>(
                bloc: context.read<TvPopularsCubit>(),
                builder: (context, state) {
                  if (state is TvPopularTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvPopularTvSuccess) {
                    return TvList(state.listPopularTvTv);
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(context, TvTopRatedPage.route),
              ),
              BlocBuilder<TvTopRatedCubit, TvTopRatedState>(
                bloc: context.read<TvTopRatedCubit>(),
                builder: (context, state) {
                  if (state is TvTopRatedTvLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TvTopRatedTvSuccess) {
                    return TvList(state.listTopRatedTv);
                  } else if (state is TvTopRatedTvFailure) {
                    return Text(state.message);
                  }
                  return const Text("Failed");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                Text('See More'),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
