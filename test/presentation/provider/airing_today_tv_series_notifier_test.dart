import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart';
import 'package:ditonton/presentation/provider/airing_today_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetAiringTodayTvSeries])
void main() {
  late MockGetAiringTodayTvSeries mockGetAiringTodayTvSeries;
  late AiringTodayTvSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTvSeries = MockGetAiringTodayTvSeries();
    notifier = AiringTodayTvSeriesNotifier(
        getAiringTodayTvSeries: mockGetAiringTodayTvSeries)
      ..addListener(() {
        listenerCallCount++;
      });
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

  test('should change state to loading when usecase is called', () async {
    when(mockGetAiringTodayTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));

    notifier.fetchAiringTodayTvSeries();

    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change tv series data when data is gotten successfully',
      () async {
    when(mockGetAiringTodayTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesList));

    await notifier.fetchAiringTodayTvSeries();

    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvSeries, tTvSeriesList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetAiringTodayTvSeries.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));

    await notifier.fetchAiringTodayTvSeries();

    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
