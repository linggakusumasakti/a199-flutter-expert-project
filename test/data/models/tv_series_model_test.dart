import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      name: 'name',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      voteAverage: 1,
      voteCount: 1);

  final tTvSeries = TvSeries(
      backdropPath: 'backdropPath',
      genreIds: [1, 2, 3],
      id: 1,
      name: 'name',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      firstAirDate: 'firstAirDate',
      voteAverage: 1,
      voteCount: 1);

  test('should be a subclass of Tv entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
