import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTvSeriesRecommendations(mockMovieRepository);
  });

  final tId = 1;
  final tTvSeries = <TvSeries>[];

  test('should get list of tv series recommendations from the response',
      () async {
    when(mockMovieRepository.getTvSeriesRecommendations(tId))
        .thenAnswer((_) async => Right(tTvSeries));

    final result = await usecase.execute(tId);
    expect(result, Right(tTvSeries));
  });
}
