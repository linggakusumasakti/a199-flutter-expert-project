import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SearchTvSeries(mockMovieRepository);
  });

  final tTvSeries = <TvSeries>[];
  final tQuery = 'name';

  test('should get list of tv series from the repository', () async {
    when(mockMovieRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(tTvSeries));
    final result = await usecase.execute(tQuery);

    expect(result, Right(tTvSeries));
  });
}
