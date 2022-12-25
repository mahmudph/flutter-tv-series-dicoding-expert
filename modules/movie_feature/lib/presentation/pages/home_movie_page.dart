import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_feature/presentation/bloc/now_playing_movie/now_playing_movie_cubit.dart';
import 'package:movie_feature/presentation/bloc/popular_movie/popular_movie_cubit.dart';
import 'package:movie_feature/presentation/bloc/top_rated_movie/top_rated_movies_cubit.dart';
import 'package:movie_feature/presentation/widgets/movie_list.dart';

import 'search_page.dart';
import 'popular_movies_page.dart';
import 'top_rated_movies_page.dart';

class HomeMoviePage extends StatefulWidget {
  static const String route = 'movie/home';

  final String onPressAbout, onPressTvs, onPressWatchlist;

  const HomeMoviePage({
    Key? key,
    required this.onPressAbout,
    required this.onPressTvs,
    required this.onPressWatchlist,
  }) : super(key: key);
  @override
  createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<NowPlayingMovieCubit>(context, listen: false)
          .fetchNowPlayingMovie();
      BlocProvider.of<TopRatedMoviesCubit>(context, listen: false)
          .fetchTopRatedMovies();
      BlocProvider.of<PopularMovieCubit>(context, listen: false)
          .fetchPopularMovies();
    });
  }

  navigator(context, routeName) => Navigator.pushNamed(context, routeName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: DrawbableMenu(
          onPressAbout: () => navigator(
            context,
            widget.onPressAbout,
          ),
          onPressMovies: () => Navigator.pushNamed(
            context,
            HomeMoviePage.route,
          ),
          onPressTvs: () => navigator(
            context,
            widget.onPressTvs,
          ),
          onPressWatchlist: () => navigator(
            context,
            widget.onPressWatchlist,
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, SearchPage.route),
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
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              BlocBuilder<NowPlayingMovieCubit, NowPlayingMovieState>(
                bloc: context.read<NowPlayingMovieCubit>(),
                builder: (context, state) {
                  if (state is NowPlayingMovieLoading) {
                    return const Center(
                      key: Key('now_playing_movie_loading'),
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NowPlayingMovieSucess) {
                    return MovieList(
                      key: const Key('now_playing_movie_list'),
                      movies: state.movies,
                    );
                  } else if (state is NowPlayingMovieFailure) {
                    return Text(
                      key: const Key('now_playing_movie_error'),
                      state.message,
                    );
                  }
                  return const Text('Failed');
                },
              ),
              SubheadingWidget(
                key: const Key('popular_movie_sub_heading'),
                title: 'Popular',
                onPress: () => Navigator.pushNamed(
                  context,
                  PopularMoviesPage.route,
                ),
              ),
              BlocBuilder<PopularMovieCubit, PopularMovieState>(
                bloc: context.read<PopularMovieCubit>(),
                builder: (context, state) {
                  if (state is PopularMovieLoading) {
                    return const Center(
                      key: Key('popular_movie_loading'),
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PopularMovieSucess) {
                    return MovieList(
                      key: const Key('popular_movie_list'),
                      movies: state.movies,
                    );
                  } else if (state is PopularMovieFailure) {
                    return Text(
                      key: const Key('popular_movie_error'),
                      state.message,
                    );
                  }
                  return const Text('Failed');
                },
              ),
              SubheadingWidget(
                key: const Key('top_rated_movie_sub_heading'),
                title: 'Top Rated',
                onPress: () => Navigator.pushNamed(
                  context,
                  TopRatedMoviesPage.route,
                ),
              ),
              BlocBuilder<TopRatedMoviesCubit, TopRatedMoviesState>(
                bloc: context.read<TopRatedMoviesCubit>(),
                builder: (context, state) {
                  if (state is TopRatedMoviesLoading) {
                    return const Center(
                      key: Key('top_rated_movie_loading'),
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is TopRatedMoviesSuccess) {
                    return MovieList(
                      key: const Key('top_rated_movie_list'),
                      movies: state.movies,
                    );
                  } else if (state is TopRatedMoviesFailure) {
                    return Text(
                      key: const Key('top_rated_movie_error'),
                      state.message,
                    );
                  }
                  return const Text('Failed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
