import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_feature/presentation/bloc/search_movie/search_movie_cubit.dart';
import 'package:movie_feature/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  static const route = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchMovieCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) => searchCubit.searchMoviesByQuery(query),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Expanded(
              child: BlocBuilder<SearchMovieCubit, SearchMovieState>(
                bloc: searchCubit,
                builder: (context, state) {
                  if (state is SearchMovieLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchMovieSuccess) {
                    if (state.movies.isEmpty) {
                      return const InformationWidget(
                        message:
                            "Data movie not found, please search with another keywords",
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        final movie = state.movies[index];
                        return MovieCard(movie);
                      },
                      itemCount: state.movies.length,
                    );
                  } else if (state is SearchMovieFailure) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
