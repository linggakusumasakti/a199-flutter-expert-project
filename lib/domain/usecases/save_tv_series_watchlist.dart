import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class SaveTvSeriesWatchList {
  final MovieRepository repository;

  SaveTvSeriesWatchList(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) {
    return repository.saveTvSeriesWatchlist(tvSeries);
  }
}
