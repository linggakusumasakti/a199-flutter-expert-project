import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late SaveTvSeriesWatchList usecase;
  late MockMovieRepository mockMovieRepository;
  
  setUp((){
    mockMovieRepository = MockMovieRepository();
    usecase = SaveTvSeriesWatchList(mockMovieRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(mockMovieRepository.saveTvSeriesWatchlist(testTvSeriesDetailForLocal))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetailForLocal);
    // assert
    verify(mockMovieRepository.saveTvSeriesWatchlist(testTvSeriesDetailForLocal));
    expect(result, Right('Added to Watchlist'));
  });
}