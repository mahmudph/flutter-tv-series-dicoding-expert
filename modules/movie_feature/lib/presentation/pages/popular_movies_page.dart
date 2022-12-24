import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_feature/presentation/bloc/popular_movie/popular_movie_cubit.dart';
import 'package:movie_feature/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class PopularMoviesPage extends StatefulWidget {
  static const route = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        BlocProvider.of<PopularMovieCubit>(context, listen: false)
            .fetchPopularMovies();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMovieCubit, PopularMovieState>(
          bloc: context.read<PopularMovieCubit>(),
          builder: (context, state) {
            if (state is PopularMovieLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularMovieSucess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  return MovieCard(movie);
                },
                itemCount: state.movies.length,
              );
            } else if (state is PopularMovieFailure) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
