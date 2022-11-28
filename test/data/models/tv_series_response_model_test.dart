import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

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

  final tvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/popular_tv_series.json'));

      final result = TvSeriesResponse.fromJson(jsonMap);

      expect(result, tvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      final result = tvSeriesResponseModel.toJson();

      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": 'backdropPath',
            "genre_ids": [1, 2, 3],
            "id": 1,
            "name": 'name',
            "overview": 'overview',
            "popularity": 1,
            "poster_path": 'posterPath',
            "first_air_date": 'firstAirDate',
            "vote_average": 1,
            "vote_count": 1,
          }
        ]
      };

      expect(result, expectedJsonMap);
    });
  });
}
