import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetAiringTodayTvSeries {
  final MovieRepository repository;

  GetAiringTodayTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getAiringTodayTvSeries();
  }
}
