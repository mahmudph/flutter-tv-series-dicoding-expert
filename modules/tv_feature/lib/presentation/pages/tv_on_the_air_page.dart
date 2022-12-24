import 'package:core/widgets/information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_feature/presentation/widgets/tv_card_list.dart';
import 'package:tv_feature/tv_feature.dart';

class TvOnTheAirPage extends StatefulWidget {
  static const route = '/on-the-air-tv';

  const TvOnTheAirPage({super.key});

  @override
  State<TvOnTheAirPage> createState() => _TvOnTheAirPageState();
}

class _TvOnTheAirPageState extends State<TvOnTheAirPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => BlocProvider.of<TvOnTheAirCubit>(context, listen: false)
          .fetchOnTheAirTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Air Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvOnTheAirCubit, TvOnTheAirState>(
          bloc: BlocProvider.of<TvOnTheAirCubit>(context),
          builder: (context, state) {
            if (state is TvOnTheAirLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvOnTheAirSuccess) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TvCard(
                    onPress: () => Navigator.pushNamed(
                      context,
                      TvDetailPage.route,
                      arguments: state.listOnTheAirTv[index].id,
                    ),
                    tv: state.listOnTheAirTv[index],
                  );
                },
                itemCount: state.listOnTheAirTv.length,
              );
            } else if (state is TvOnTheAirFailure) {
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
