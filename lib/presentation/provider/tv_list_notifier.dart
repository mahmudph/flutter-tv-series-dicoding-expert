import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/material.dart';

class TvListNotifier extends ChangeNotifier {
  var _onTheAirTvShowTv = <Tv>[];
  List<Tv> get onTheAirTvShowTv => _onTheAirTvShowTv;

  RequestState _onTheAirTvShowState = RequestState.Empty;
  RequestState get onTheAirTvShowState => _onTheAirTvShowState;

  var _popularTv = <Tv>[];
  List<Tv> get popularTv => _popularTv;

  RequestState _popularTvState = RequestState.Empty;
  RequestState get popularTvState => _popularTvState;

  var _topRatedTv = <Tv>[];
  List<Tv> get topRatedTv => _topRatedTv;

  RequestState _topRatedTvState = RequestState.Empty;
  RequestState get topRatedTvState => _topRatedTvState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getOnTheAirTvShow,
    required this.getPopularTv,
    required this.getTopRatedTv,
  });

  final GetOnTheAirTVShows getOnTheAirTvShow;
  final GetPopularTv getPopularTv;
  final GetTopRatedTv getTopRatedTv;

  Future<void> fetchOnTheAirTvShow() async {
    _onTheAirTvShowState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTvShow.execute();
    result.fold(
      (failure) {
        _onTheAirTvShowState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _onTheAirTvShowState = RequestState.Loaded;
        _onTheAirTvShowTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTv() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTv.execute();
    result.fold(
      (failure) {
        _popularTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _popularTvState = RequestState.Loaded;
        _popularTv = tvData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTv() async {
    _topRatedTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvData) {
        _topRatedTvState = RequestState.Loaded;
        _topRatedTv = tvData;
        notifyListeners();
      },
    );
  }
}
