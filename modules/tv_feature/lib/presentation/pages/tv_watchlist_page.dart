import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_feature/presentation/bloc/tv_watchlist/tv_watchlist_cubit.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';

import 'tv_detail_page.dart';

class TvWatchlistPage extends StatefulWidget {
  const TvWatchlistPage({super.key});

  @override
  State<TvWatchlistPage> createState() => _TvWatchlistPageState();
}

class _TvWatchlistPageState extends State<TvWatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<TvWatchlistCubit>(context, listen: false)
          .loadTvWatchlist(),
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
    BlocProvider.of<TvWatchlistCubit>(context, listen: false).loadTvWatchlist();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<TvWatchlistCubit, TvWatchlistState>(
        builder: (context, state) {
          if (state is TvWatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvWatchlistSuccess) {
            if (state.tv.isEmpty) {
              return const Center(
                child: Text("Data watchlist tv not found"),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.tv[index];
                return TvCard(
                  onPress: () => Navigator.pushNamed(
                    context,
                    TvDetailPage.route,
                    arguments: tv.id,
                  ),
                  tv: tv,
                );
              },
              itemCount: state.tv.length,
            );
          } else if (state is TvWatchlistFailure) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
