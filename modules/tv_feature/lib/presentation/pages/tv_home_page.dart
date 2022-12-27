import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_feature/presentation/bloc/bloc.dart';
import 'package:tv_feature/presentation/widgets/tv_list.dart';

import 'tv_on_the_air_page.dart';
import 'tv_populars_page.dart';
import 'tv_search_page.dart';
import 'tv_top_rated_page.dart';

class TvHomePage extends StatefulWidget {
  static const String route = "tv/home";

  final String onPressWatchlist, onPressAbout, onPressMovies;

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
    handleOnLoadData();
  }

  void handleOnLoadData() {
    Future.microtask(() {
      BlocProvider.of<TvPopularsCubit>(context, listen: false).fetchPopulartv();
      BlocProvider.of<TvTopRatedCubit>(context, listen: false)
          .fetchTopRatedTv();
      BlocProvider.of<TvOnTheAirCubit>(context, listen: false)
          .fetchOnTheAirTvs();
    });
  }

  void navigate(BuildContext context, String routeName) => Navigator.pushNamed(
        context,
        routeName,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawbableMenu(
          onPressMovies: () => navigate(context, widget.onPressMovies),
          onPressAbout: () => navigate(context, widget.onPressAbout),
          onPressWatchlist: () => navigate(context, widget.onPressWatchlist),
          onPressTvs: () => navigate(context, TvHomePage.route),
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton Aja'),
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
        child: RefreshIndicator(
          onRefresh: () async => handleOnLoadData(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubheadingWidget(
                  key: const Key('on_the_air_tv'),
                  title: 'On The Air',
                  onPress: () => Navigator.pushNamed(
                    context,
                    TvOnTheAirPage.route,
                  ),
                ),
                BlocBuilder<TvOnTheAirCubit, TvOnTheAirState>(
                  bloc: context.read<TvOnTheAirCubit>(),
                  builder: (context, state) {
                    if (state is TvOnTheAirLoading) {
                      return const Center(
                        key: Key('on_the_air_tv_loading'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvOnTheAirSuccess) {
                      return TvList(
                        key: const Key('on_the_air_tv_list'),
                        tvs: state.listOnTheAirTv,
                      );
                    } else if (state is TvOnTheAirFailure) {
                      return Text(state.message);
                    }
                    return const Text("Failed");
                  },
                ),
                SubheadingWidget(
                  key: const Key('populars_tv'),
                  title: 'Popular',
                  onPress: () => Navigator.pushNamed(
                    context,
                    TvPopularsPage.route,
                  ),
                ),
                BlocBuilder<TvPopularsCubit, TvPopularsState>(
                  bloc: context.read<TvPopularsCubit>(),
                  builder: (context, state) {
                    if (state is TvPopularTvLoading) {
                      return const Center(
                        key: Key('popular_tv_loading'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvPopularTvSuccess) {
                      return TvList(
                        key: const Key('populars_tv_list'),
                        tvs: state.listPopularTvTv,
                      );
                    } else if (state is TvPopularTvFailure) {
                      return Text(state.message);
                    } else {
                      return const Text('Failed');
                    }
                  },
                ),
                SubheadingWidget(
                  key: const Key('top_rated_tv'),
                  title: 'Top Rated',
                  onPress: () => Navigator.pushNamed(
                    context,
                    TvTopRatedPage.route,
                  ),
                ),
                BlocBuilder<TvTopRatedCubit, TvTopRatedState>(
                  bloc: context.read<TvTopRatedCubit>(),
                  builder: (context, state) {
                    if (state is TvTopRatedTvLoading) {
                      return const Center(
                        key: Key('top_rated_tv_loading'),
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvTopRatedTvSuccess) {
                      return TvList(
                        key: const Key('top_rated_tv_list'),
                        tvs: state.listTopRatedTv,
                      );
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
      ),
    );
  }
}
