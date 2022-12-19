import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';
import 'package:tv_feature/presentation/bloc/tv_top_rated/tv_top_rated_cubit.dart';
import 'package:tv_feature/tv_feature.dart';

class TvTopRatedPage extends StatefulWidget {
  static const route = '/top-rated-tv';

  const TvTopRatedPage({super.key});

  @override
  State<TvTopRatedPage> createState() => _TvTopRatedPageState();
}

class _TvTopRatedPageState extends State<TvTopRatedPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<TvTopRatedCubit>(context, listen: false)
          .fetchTopRatedTv(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvTopRatedCubit, TvTopRatedState>(
          bloc: BlocProvider.of<TvTopRatedCubit>(context, listen: false),
          builder: (context, state) {
            if (state is TvTopRatedTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvTopRatedTvSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvCard(
                    onPress: () => Navigator.pushNamed(
                      context,
                      TvDetailPage.route,
                      arguments: state.listTopRatedTv[index].id,
                    ),
                    tv: state.listTopRatedTv[index],
                  );
                },
                itemCount: state.listTopRatedTv.length,
              );
            } else if (state is TvTopRatedTvFailure) {
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
