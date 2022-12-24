import 'package:core/core.dart';
import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_feature/presentation/widgets/movie_card_list.dart';
import 'package:movie_feature/presentation/bloc/watchlist_movie/watchlist_movie_cubit.dart';

class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<WatchlistMovieCubit>(context, listen: false)
          .loadMovieWatchlist(),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    BlocProvider.of<WatchlistMovieCubit>(context, listen: false)
        .loadMovieWatchlist();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieCubit, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistMovieDataSuccess) {
            if (state.movies.isEmpty) {
              return const Center(
                child: InformationWidget(
                  title: "Data Not Found!",
                  message:
                      "Data Watchlist Movie not found. data wathlist movie will be show hire when you add it",
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(movie);
              },
              itemCount: state.movies.length,
            );
          } else if (state is WatchlistMovieFailure) {
            return Center(
              key: const Key('error_message'),
              child: InformationWidget(
                message: state.message,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
