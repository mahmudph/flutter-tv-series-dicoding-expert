import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_on_the_air_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TvOnTheAirPage extends StatefulWidget {
  static const ROUTE_NAME = '/on-the-air-tv';

  @override
  _TvOnTheAirPageState createState() => _TvOnTheAirPageState();
}

class _TvOnTheAirPageState extends State<TvOnTheAirPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TvOnTheAirNotifier>(context, listen: false)
          .fetchOnTheAirTvs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On The Air Tv'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TvOnTheAirNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvs[index];
                  return TvCard(tv);
                },
                itemCount: data.tvs.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}