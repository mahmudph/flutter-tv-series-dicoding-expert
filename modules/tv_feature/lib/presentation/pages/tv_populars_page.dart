import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';
import 'package:tv_feature/tv_feature.dart';

class TvPopularsPage extends StatefulWidget {
  static const route = '/popular-tv';

  const TvPopularsPage({super.key});

  @override
  State<TvPopularsPage> createState() => _TvPopularsPageState();
}

class _TvPopularsPageState extends State<TvPopularsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TvPopularsCubit>(
        context,
        listen: false,
      ).fetchPopulartv(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvPopularsCubit, TvPopularsState>(
          bloc: BlocProvider.of<TvPopularsCubit>(context, listen: false),
          builder: (context, state) {
            if (state is TvPopularTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvPopularTvSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvCard(
                    onPress: () => Navigator.pushNamed(
                      context,
                      TvDetailPage.route,
                      arguments: state.listPopularTvTv[index].id,
                    ),
                    tv: state.listPopularTvTv[index],
                  );
                },
                itemCount: state.listPopularTvTv.length,
              );
            } else if (state is TvPopularTvFailure) {
              return Center(
                key: const Key('error_message'),
                child: InformationWidget(message: state.message),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
