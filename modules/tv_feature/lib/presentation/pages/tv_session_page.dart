import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tv_feature/presentation/widgets/tv_seasson_episode.dart';
import 'package:tv_feature/tv_feature.dart';

class TvSessionPage extends StatefulWidget {
  static const String route = '/tv/session';

  final int tvId, tvSessionId;

  const TvSessionPage({
    Key? key,
    required this.tvId,
    required this.tvSessionId,
  }) : super(key: key);

  @override
  State<TvSessionPage> createState() => _TvSessionPageState();
}

class _TvSessionPageState extends State<TvSessionPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => BlocProvider.of<TvSessionCubit>(context).getTvSessions(
        widget.tvId,
        widget.tvSessionId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder(
          bloc: context.read<TvSessionCubit>(),
          builder: (_, state) {
            if (state is TvSessionLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSessionSuccess) {
              return TvSessionDetail(
                tvId: widget.tvId,
                tvSession: state.session,
              );
            } else if (state is TvSessionFailure) {
              return InformationWidget(message: state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class TvSessionDetail extends StatelessWidget {
  final TvSession tvSession;
  final int tvId;

  const TvSessionDetail({
    Key? key,
    required this.tvId,
    required this.tvSession,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseUrlImage${tvSession.posterPath}',
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
                              tvSession.name,
                              style: kHeading5,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSession.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Episodes",
                              style: kHeading6,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ListView.separated(
                                key: const Key('list_tv_sessions'),
                                shrinkWrap: true,
                                itemCount: tvSession.episodes.length,
                                separatorBuilder: (_, i) => SizedBox(
                                  width:
                                      tvSession.episodes.length != i ? 10 : 0,
                                ),
                                itemBuilder: (_, index) {
                                  return TvSeassonEpisode(
                                    episode: tvSession.episodes[index],
                                    onPress: () => Navigator.pushNamed(
                                      context,
                                      TvSesionEpisodePage.route,
                                      arguments: {
                                        'tvId': tvId,
                                        'tvSessionId': tvSession.seasonNumber,
                                        'tvSessionEpisodeId': tvSession
                                            .episodes[index].episodeNumber,
                                      },
                                    ),
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                              ),
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
}
