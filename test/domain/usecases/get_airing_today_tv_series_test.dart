import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetAiringTodayTvSeries usecase;
  late MockMovieRepository mockMovieRepository;

  setUp((){
    mockMovieRepository = MockMovieRepository();
    usecase = GetAiringTodayTvSeries(mockMovieRepository);
  });

  final tTvSeries = <TvSeries>[];

  group('GetAiringTodayTvSeries Tests', () {
    group('execute', () {
      test(
          'should get list of tv series from the repository when execute function is called',
              () async {
            when(mockMovieRepository.getAiringTodayTvSeries())
                .thenAnswer((_) async => Right(tTvSeries));

            final result = await usecase.execute();

            expect(result, Right(tTvSeries));
          });
    });
  });
}