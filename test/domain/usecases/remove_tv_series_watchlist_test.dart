import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveTvSeriesWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp((){
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveTvSeriesWatchlist(mockMovieRepository);
  });

  test('should remove tv series watchlist from repository', () async{
    when(mockMovieRepository.removeTvSeriesWatchList(testTvSeriesDetailForLocal))
        .thenAnswer((_) async => Right('Removed from watchlist'));

    final result = await usecase.execute(testTvSeriesDetailForLocal);

    verify(mockMovieRepository.removeTvSeriesWatchList(testTvSeriesDetailForLocal));
    expect(result, Right('Removed from watchlist'));
  });
}