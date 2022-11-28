import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter/foundation.dart';

class MovieSearchNotifier extends ChangeNotifier {
  final SearchMovies searchMovies;
  final SearchTvSeries searchTvSeries;

  MovieSearchNotifier({
    required this.searchMovies,
    required this.searchTvSeries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  RequestState _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<Movie> _searchResult = [];
  List<Movie> get searchResult => _searchResult;

  List<TvSeries> _searchTvSeriesResult = [];
  List<TvSeries> get searchTvSeriesResult => _searchTvSeriesResult;

  String _message = '';
  String get message => _message;

  Future<void> fetchMovieSearch(String query) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchMovies.execute(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (data) {
        _searchResult = data;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvSeriesSearch(String query) async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await searchTvSeries.execute(query);
    result.fold(
          (failure) {
        _message = failure.message;
        _tvSeriesState = RequestState.Error;
        notifyListeners();
      },
          (data) {
        _searchTvSeriesResult = data;
        _tvSeriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
