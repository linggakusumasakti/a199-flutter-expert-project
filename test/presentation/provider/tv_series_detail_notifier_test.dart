import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_notifier_test.mocks.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  SaveTvSeriesWatchList,
  RemoveTvSeriesWatchlist
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockSaveTvSeriesWatchList mockSaveTvSeriesWatchList;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;
  late MockGetWatchListStatus mockGetWatchlistStatus;

  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockSaveTvSeriesWatchList = MockSaveTvSeriesWatchList();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    mockGetWatchlistStatus = MockGetWatchListStatus();

    provider = TvSeriesDetailNotifier(
        getTvSeriesDetail: mockGetTvSeriesDetail,
        getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
        saveTvSeriesWatchList: mockSaveTvSeriesWatchList,
        removeTvSeriesWatchlist: mockRemoveTvSeriesWatchlist,
        getWatchListStatus: mockGetWatchlistStatus)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

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

  void _arrangeUsecase() {
    when(mockGetTvSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTvSeriesDetail));
    when(mockGetTvSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTvSeriesList));
  }

  group('Get Tv Series Detail', () {
    test('should get data from the usecase', () async {
      _arrangeUsecase();

      await provider.fetchTvSeriesDetail(tId);

      verify(mockGetTvSeriesDetail.execute(tId));
    });

    test('should changestate to loading when usecase is called ', () {
      _arrangeUsecase();

      provider.fetchTvSeriesDetail(tId);

      expect(provider.tvSeriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv series when data is gotten successfully', () async {
      _arrangeUsecase();

      await provider.fetchTvSeriesDetail(tId);

      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeries, testTvSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test(
        'should change recommendation tv series when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTvSeriesList);
    });
  });

  group('Get Tv Series Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      verify(mockGetTvSeriesRecommendations.execute(tId));
      expect(provider.tvSeriesRecommendations, tTvSeriesList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesRecommendationsState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTvSeriesList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      when(mockGetTvSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTvSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesRecommendationsState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveTvSeriesWatchList.execute(testTvSeriesDetailForLocal))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTvSeriesDetailForLocal.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchList(testTvSeriesDetailForLocal);
      // assert
      verify(mockSaveTvSeriesWatchList.execute(testTvSeriesDetailForLocal));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetailForLocal))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTvSeriesDetailForLocal.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTvSeriesDetailForLocal);
      // assert
      verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetailForLocal));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveTvSeriesWatchList.execute(testTvSeriesDetailForLocal))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTvSeriesDetailForLocal.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchList(testTvSeriesDetailForLocal);
      // assert
      verify(mockGetWatchlistStatus.execute(testTvSeriesDetailForLocal.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveTvSeriesWatchList.execute(testTvSeriesDetailForLocal))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTvSeriesDetailForLocal.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchList(testTvSeriesDetailForLocal);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });
}
