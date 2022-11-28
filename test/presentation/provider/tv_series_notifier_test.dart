import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_notifier_test.mocks.dart';

@GenerateMocks(
    [GetPopularTvSeries, GetTopRatedTvSeries, GetAiringTodayTvSeries])
void main() {
  late TvSeriesNotifier provider;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late MockGetAiringTodayTvSeries mockGetAiringTodayTvSeries;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    mockGetAiringTodayTvSeries = MockGetAiringTodayTvSeries();
    provider = TvSeriesNotifier(
        getPopularTvSeries: mockGetPopularTvSeries,
        getTopRatedTvSeries: mockGetTopRatedTvSeries,
        getAiringTodayTvSeries: mockGetAiringTodayTvSeries);
  });

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

  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('popular tv series', () {
    test('initialState should be Empty', () {
      expect(provider.popularTvSeriesState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      provider.fetchPopularTvSeries();

      verify(mockGetPopularTvSeries.execute());
    });

    test('should change tv series when data is gotten successfully', () async {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      await provider.fetchPopularTvSeries();

      expect(provider.popularTvSeriesState, RequestState.Loaded);
      expect(provider.popularTvSeries, tTvSeriesList);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await provider.fetchPopularTvSeries();

      expect(provider.popularTvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });

  group('top rated tv series', () {
    test('initialState should be Empty', () {
      expect(provider.topRatedTvSeriesState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      provider.fetchTopRatedTvSeries();

      verify(mockGetTopRatedTvSeries.execute());
    });

    test('should change tv series when data is gotten successfully', () async {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      await provider.fetchPopularTvSeries();

      expect(provider.popularTvSeriesState, RequestState.Loaded);
      expect(provider.popularTvSeries, tTvSeriesList);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await provider.fetchTopRatedTvSeries();

      expect(provider.topRatedTvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });

  group('airing today tv series', () {
    test('initialState should be Empty', () {
      expect(provider.airingTodayTvSeriesState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      when(mockGetAiringTodayTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      provider.fetchAiringTodayTvSeries();

      verify(mockGetAiringTodayTvSeries.execute());
    });

    test('should change tv series when data is gotten successfully', () async {
      when(mockGetAiringTodayTvSeries.execute())
          .thenAnswer((_) async => Right(tTvSeriesList));

      await provider.fetchAiringTodayTvSeries();

      expect(provider.airingTodayTvSeriesState, RequestState.Loaded);
      expect(provider.airingTodayTvSeries, tTvSeriesList);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetAiringTodayTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

      await provider.fetchAiringTodayTvSeries();

      expect(provider.airingTodayTvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
    });
  });
}
