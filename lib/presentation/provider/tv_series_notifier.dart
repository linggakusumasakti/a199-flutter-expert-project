import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class TvSeriesNotifier extends ChangeNotifier {
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;
  final GetAiringTodayTvSeries getAiringTodayTvSeries;

  TvSeriesNotifier(
      {required this.getPopularTvSeries,
      required this.getTopRatedTvSeries,
      required this.getAiringTodayTvSeries});

  RequestState _popularTvSeriesState = RequestState.Empty;
  RequestState get popularTvSeriesState => _popularTvSeriesState;

  RequestState _topRatedTvSeriesState = RequestState.Empty;
  RequestState get topRatedTvSeriesState => _topRatedTvSeriesState;

  RequestState _airingTodayTvSeriesState = RequestState.Empty;
  RequestState get airingTodayTvSeriesState => _airingTodayTvSeriesState;

  List<TvSeries> _popularTvSeries = [];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  List<TvSeries> _topRatedTvSeries = [];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  List<TvSeries> _airingTodayTvSeries = [];
  List<TvSeries> get airingTodayTvSeries => _airingTodayTvSeries;

  String _message = '';

  String get message => _message;

  Future<void> fetchPopularTvSeries() async {
    _popularTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();

    result.fold((failure) {
      _message = failure.message;
      _popularTvSeriesState = RequestState.Error;
      notifyListeners();
    }, (tvSeriesData) {
      _popularTvSeries = tvSeriesData;
      _popularTvSeriesState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();

    result.fold((failure) {
      _message = failure.message;
      _topRatedTvSeriesState = RequestState.Error;
      notifyListeners();
    }, (tVSeriesData) {
      _topRatedTvSeries = tVSeriesData;
      _topRatedTvSeriesState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Future<void> fetchAiringTodayTvSeries() async {
    _airingTodayTvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getAiringTodayTvSeries.execute();

    result.fold((failure) {
      _message = failure.message;
      _airingTodayTvSeriesState = RequestState.Error;
      notifyListeners();
    }, (tVSeriesData) {
      _airingTodayTvSeries = tVSeriesData;
      _airingTodayTvSeriesState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
