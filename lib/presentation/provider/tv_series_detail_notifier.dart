import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:flutter/cupertino.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final SaveTvSeriesWatchList saveTvSeriesWatchList;
  final RemoveTvSeriesWatchlist removeTvSeriesWatchlist;
  final GetWatchListStatus getWatchListStatus;

  TvSeriesDetailNotifier(
      {required this.getTvSeriesDetail,
      required this.getTvSeriesRecommendations,
      required this.saveTvSeriesWatchList,
      required this.removeTvSeriesWatchlist,
      required this.getWatchListStatus});

  late TvSeriesDetail _tvSeries;
  TvSeriesDetail get tvSeries => _tvSeries;

  List<TvSeries> _tvSeriesRecommendations = [];
  List<TvSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;

  RequestState _tvSeriesRecommendationsState = RequestState.Empty;
  RequestState get tvSeriesRecommendationsState => _tvSeriesRecommendationsState;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);
    detailResult.fold((failure) {
      _tvSeriesState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeries) {
      _tvSeriesRecommendationsState = RequestState.Loading;
      _tvSeries = tvSeries;
    notifyListeners();
      recommendationResult.fold((failure) {
        _tvSeriesRecommendationsState = RequestState.Error;
        _message = failure.message;
      }, (recommendations) {
        _tvSeriesRecommendationsState = RequestState.Loaded;
        _tvSeriesRecommendations = recommendations;
      });
      _tvSeriesState = RequestState.Loaded;
      notifyListeners();
    });
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;


  Future<void> addWatchList(TvSeriesDetail tvSeries) async {
    final result = await saveTvSeriesWatchList.execute(tvSeries);

    await result.fold((failure){
      _watchlistMessage = failure.message;
    } , (successMessage) async {
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> removeFromWatchlist(TvSeriesDetail tvSeries) async {
    final result = await removeTvSeriesWatchlist.execute(tvSeries);

    await result.fold((failure) async {
      _watchlistMessage = failure.message;
    }, (successMessage) async {
      _watchlistMessage = successMessage;
    });

    await loadWatchlistStatus(tvSeries.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
