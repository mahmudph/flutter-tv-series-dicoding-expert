import 'package:core/core.dart';
import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_feature/domain/entitas/genre.dart';
import 'package:tv_feature/domain/entitas/tv_detail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_feature/presentation/bloc/tv_details/tv_details_cubit.dart';
import 'package:tv_feature/presentation/bloc/tv_recomendations/tv_recomendations_cubit.dart';
import 'package:tv_feature/presentation/bloc/tv_watchlist_status/tv_watchlist_status_cubit.dart';
import 'package:tv_feature/presentation/widgets/tv_seasson_list.dart';

class TvDetailPage extends StatefulWidget {
  static const route = '/tv/detail';

  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<TvDetailsCubit>(context, listen: false)
          .fetchTvDetail(widget.id);
      BlocProvider.of<TvRecomendationsCubit>(context, listen: false)
          .loadTvRecommendations(widget.id);
      BlocProvider.of<TvWatchlistStatusCubit>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailsCubit, TvDetailsState>(
        bloc: BlocProvider.of<TvDetailsCubit>(context, listen: false),
        builder: (context, state) {
          if (state is TvDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailsSuccess) {
            final tv = state.tvDetail;
            return SafeArea(
              child: DetailContent(
                tv: tv,
              ),
            );
          } else if (state is TvDetailsFailure) {
            return Center(
              key: const Key('error_message'),
              child: InformationWidget(message: state.message),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvDetail tv;

  const DetailContent({
    Key? key,
    required this.tv,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final watchlistCubit = context.read<TvWatchlistStatusCubit>();
    final tvRecommendation = context.read<TvRecomendationsCubit>();

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseUrlImage${tv.posterPath}',
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
                              tv.name,
                              style: kHeading5,
                            ),
                            BlocConsumer<TvWatchlistStatusCubit,
                                TvWatchlistStatusState>(
                              bloc: watchlistCubit,
                              listener: (context, state) {
                                if (state is TvWatchlistStatusData) {
                                  if (state.message.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                      ),
                                    );
                                  }
                                }
                              },
                              builder: (_, state) {
                                return ElevatedButton(
                                  onPressed: () {
                                    if (state is TvWatchlistStatusData) {
                                      if (state.isAddedWatchlist) {
                                        watchlistCubit.removeFromWatchlist(
                                          tv,
                                        );
                                      } else {
                                        watchlistCubit.addWatchlist(tv);
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      (state is TvWatchlistStatusData)
                                          ? state.isAddedWatchlist
                                              ? const Icon(Icons.check)
                                              : const Icon(Icons.add)
                                          : const SizedBox(),
                                      const Text('Watchlist'),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Text(
                              _showGenres(tv.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Seasons",
                              style: kHeading6,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ListView.separated(
                                key: const Key('list_tv_sessions'),
                                shrinkWrap: true,
                                itemCount: tv.seasons.length,
                                separatorBuilder: (_, i) => SizedBox(
                                  width: tv.seasons.length != i ? 10 : 0,
                                ),
                                itemBuilder: (_, index) {
                                  return TvSeasson(
                                    season: tv.seasons[index],
                                    defaultPosterPath: tv.posterPath,
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<TvRecomendationsCubit,
                                TvRecomendationsState>(
                              bloc: tvRecommendation,
                              builder: (context, state) {
                                if (state is TvRecommendationLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is TvRecommendationFailure) {
                                  return Text(state.message);
                                } else if (state is TvRecommendationSuccess) {
                                  return SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      key: const Key('tv_recommendation_list'),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final tv =
                                            state.listRecomendationsTv[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                TvDetailPage.route,
                                                arguments: tv.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    '$baseUrlImage${tv.posterPath}',
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
                                      itemCount:
                                          state.listRecomendationsTv.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
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
}
