import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_feature/domain/entities/genre.dart';
import 'package:movie_feature/domain/entities/movie_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie_feature/presentation/bloc/movie_detail/movie_detail_cubit.dart';
import 'package:movie_feature/presentation/bloc/recomendation_movies/recommendation_movies_cubit.dart';
import 'package:movie_feature/presentation/bloc/watchlist_movie_status/watchlist_movie_status_cubit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';

class MovieDetailPage extends StatefulWidget {
  static const route = '/detail';

  final int id;
  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        BlocProvider.of<MovieDetailCubit>(context, listen: false)
            .loadMovieDetail(widget.id);
        BlocProvider.of<RecommendationMoviesCubit>(context, listen: false)
            .fetchRecommendationMovies(widget.id);
        BlocProvider.of<WatchlistMovieStatusCubit>(context, listen: false)
            .loadWatchlistStatus(widget.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        bloc: context.read<MovieDetailCubit>(),
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailSuccess) {
            return SafeArea(
              child: DetailContent(
                movieDetail: state.movieDetail,
              ),
            );
          } else if (state is MovieDetailFailure) {
            return Text(state.message);
          }
          return const Text('failure');
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movieDetail;

  const DetailContent({Key? key, required this.movieDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final watchlistStatusCubit = context.read<WatchlistMovieStatusCubit>();
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseUrlImage${movieDetail.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieDetail.title,
                              style: kHeading5,
                            ),
                            BlocConsumer<WatchlistMovieStatusCubit,
                                WatchlistMovieStatusState>(
                              bloc: watchlistStatusCubit,
                              listener: (_, state) {
                                if (state is WatchlistMovieStatusData &&
                                    state.message.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                    ),
                                  );
                                }
                              },
                              builder: (_, state) {
                                var isAddToWachlist = false;

                                if (state is WatchlistMovieStatusData) {
                                  isAddToWachlist = state.isAddToWatchlist;
                                }

                                return ElevatedButton(
                                  onPressed: () async {
                                    if (!isAddToWachlist) {
                                      watchlistStatusCubit
                                          .addWatchlist(movieDetail);
                                    } else {
                                      watchlistStatusCubit
                                          .removeFromWatchlist(movieDetail);
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAddToWachlist
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.add),
                                      const Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              _showGenres(movieDetail.genres),
                            ),
                            Text(
                              _showDuration(movieDetail.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movieDetail.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movieDetail.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movieDetail.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<RecommendationMoviesCubit,
                                RecommendationMoviesState>(
                              bloc: context.read<RecommendationMoviesCubit>(),
                              builder: (context, state) {
                                if (state is RecommendationMoviesLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      key: Key('loading_recommendation_movies'),
                                    ),
                                  );
                                } else if (state
                                    is RecommendationMoviesSuccess) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      key: const Key(
                                        'list_recommendation_movies',
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = state.movies[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.route,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$baseUrlImage${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: state.movies.length,
                                    ),
                                  );
                                } else if (state
                                    is RecommendationMoviesFailure) {
                                  return Text(state.message);
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
