import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:flutter/foundation.dart';

class TvOnTheAirNotifier extends ChangeNotifier {
  final GetOnTheAirTVShows getOnTheAirTvShow;

  TvOnTheAirNotifier({required this.getOnTheAirTvShow});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvs = [];
  List<Tv> get tvs => _tvs;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnTheAirTvs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTvShow.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvs) {
        _tvs = tvs;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
