import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_feature/tv_feature.dart';

class TvSesionEpisodePage extends StatefulWidget {
  static const String route = '/tv/session/episode';

  final int tvId, tvSessionId, tvSessionEpisodeId;

  const TvSesionEpisodePage({
    Key? key,
    required this.tvId,
    required this.tvSessionId,
    required this.tvSessionEpisodeId,
  }) : super(key: key);

  @override
  State<TvSesionEpisodePage> createState() => _TvSesionEpisodePageState();
}

class _TvSesionEpisodePageState extends State<TvSesionEpisodePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () =>
          BlocProvider.of<TvSessionEpisodeCubit>(context).loadTvSessionEpisode(
        widget.tvId,
        widget.tvSessionId,
        widget.tvSessionEpisodeId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder(
          bloc: context.read<TvSessionEpisodeCubit>(),
          builder: (_, state) {
            if (state is TvSessionEpisodeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvSessionEpisodeSuccess) {
              return TvSessionEpisodeDetail(tvSessionEpisode: state.episode);
            } else if (state is TvSessionEpisodeFailure) {
              return InformationWidget(message: state.message);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class TvSessionEpisodeDetail extends StatelessWidget {
  final Episode tvSessionEpisode;

  const TvSessionEpisodeDetail({
    Key? key,
    required this.tvSessionEpisode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseUrlImage${tvSessionEpisode.stillPath}',
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
                              tvSessionEpisode.name,
                              style: kHeading5,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tvSessionEpisode.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Release Date',
                              style: kHeading6,
                            ),
                            Text(
                              tvSessionEpisode.airDate ?? '-',
                            ),
                            const SizedBox(height: 16),
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
            initialChildSize: 0.8,
            minChildSize: 0.8,
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
