import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetTopRatedTvSeries(mockMovieRepository);
  });

  final tTvSeries = <TvSeries>[];

  group('GetTopRatedTvSeries', () {
    group('execute', () {
      test(
          'should get list tv series from the repository when execute function is called',
          () async {
        when(mockMovieRepository.getTopRatedTvSeries())
            .thenAnswer((_) async => Right(tTvSeries));

        final result = await usecase.execute();

        expect(result, Right(tTvSeries));
      });
    });
  });
}
