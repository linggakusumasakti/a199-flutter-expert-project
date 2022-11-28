import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();
    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
    isMovie: 1
  );

  final tTvSeriesModel = TvSeriesModel(
      backdropPath: '/35SS0nlBhu28cSe7TiO3ZiywZhl.jpg',
      genreIds: [10759, 18],
      id: 77169,
      name: 'Cobra Kai',
      overview:
      'This Karate Kid sequel series picks up 30 years after the events of the 1984 All Valley Karate Tournament and finds Johnny Lawrence on the hunt for redemption by reopening the infamous Cobra Kai karate dojo. This reignites his old rivalry with the successful Daniel LaRusso, who has been working to maintain the balance in his life without mentor Mr. Miyagi.',
      popularity: 4668.244,
      posterPath: '/6POBWybSBDBKjSs1VAQcnQC1qyt.jpg',
      firstAirDate: '2018-05-02',
      voteAverage: 8.1,
      voteCount: 3917);

  final tTvSeries = TvSeries(
      backdropPath: '/35SS0nlBhu28cSe7TiO3ZiywZhl.jpg',
      genreIds: [10759, 18],
      id: 77169,
      name: 'Cobra Kai',
      overview:
      'This Karate Kid sequel series picks up 30 years after the events of the 1984 All Valley Karate Tournament and finds Johnny Lawrence on the hunt for redemption by reopening the infamous Cobra Kai karate dojo. This reignites his old rivalry with the successful Daniel LaRusso, who has been working to maintain the balance in his life without mentor Mr. Miyagi.',
      popularity: 4668.244,
      posterPath: '/6POBWybSBDBKjSs1VAQcnQC1qyt.jpg',
      firstAirDate: '2018-05-02',
      voteAverage: 8.1,
      voteCount: 3917);

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Now Playing Movies', () {
    test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingMovies())
              .thenAnswer((_) async => tMovieModelList);
          // act
          final result = await repository.getNowPlayingMovies();
          // assert
          verify(mockRemoteDataSource.getNowPlayingMovies());
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tMovieList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingMovies())
              .thenThrow(ServerException());
          // act
          final result = await repository.getNowPlayingMovies();
          // assert
          verify(mockRemoteDataSource.getNowPlayingMovies());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getNowPlayingMovies())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getNowPlayingMovies();
          // assert
          verify(mockRemoteDataSource.getNowPlayingMovies());
          expect(result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Popular Movies', () {
    test('should return movie list when call to data source is success',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenAnswer((_) async => tMovieModelList);
          // act
          final result = await repository.getPopularMovies();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tMovieList);
        });

    test(
        'should return server failure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenThrow(ServerException());
          // act
          final result = await repository.getPopularMovies();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return connection failure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getPopularMovies())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getPopularMovies();
          // assert
          expect(
              result,
              Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Top Rated Movies', () {
    test('should return movie list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedMovies())
              .thenAnswer((_) async => tMovieModelList);
          // act
          final result = await repository.getTopRatedMovies();
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tMovieList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedMovies())
              .thenThrow(ServerException());
          // act
          final result = await repository.getTopRatedMovies();
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTopRatedMovies())
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTopRatedMovies();
          // assert
          expect(
              result,
              Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('Get Movie Detail', () {
    final tId = 1;
    final tMovieResponse = MovieDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      imdbId: 'imdb1',
      originalLanguage: 'en',
      originalTitle: 'originalTitle',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return Movie data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getMovieDetail(tId))
              .thenAnswer((_) async => tMovieResponse);
          // act
          final result = await repository.getMovieDetail(tId);
          // assert
          verify(mockRemoteDataSource.getMovieDetail(tId));
          expect(result, equals(Right(testMovieDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getMovieDetail(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getMovieDetail(tId);
          // assert
          verify(mockRemoteDataSource.getMovieDetail(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getMovieDetail(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getMovieDetail(tId);
          // assert
          verify(mockRemoteDataSource.getMovieDetail(tId));
          expect(result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getMovieRecommendations(tId))
              .thenAnswer((_) async => tMovieList);
          // act
          final result = await repository.getMovieRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getMovieRecommendations(tId));
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tMovieList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getMovieRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getMovieRecommendations(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getMovieRecommendations(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getMovieRecommendations(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getMovieRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getMovieRecommendations(tId));
          expect(result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Seach Movies', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchMovies(tQuery))
              .thenAnswer((_) async => tMovieModelList);
          // act
          final result = await repository.searchMovies(tQuery);
          // assert
          /* workaround to test List in Right. Issue: https://github.com/spebbe/dartz/issues/80 */
          final resultList = result.getOrElse(() => []);
          expect(resultList, tMovieList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchMovies(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchMovies(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchMovies(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchMovies(tQuery);
          // assert
          expect(
              result,
              Left(ConnectionFailure('Failed to connect to the network')));
        });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveWatchlist(testMovieDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveWatchlist(testMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testMovieDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testMovieDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(tId);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of Movies', () async {
      // arrange
      when(mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieTable]);
      // act
      final result = await repository.getWatchlistMovies();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });

  group('Popolar Tv Series', () {
    test(
        'should return remote data when the call remote data source is successful',
            () async {
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenAnswer((_) async => tTvSeriesModelList);

          final result = await repository.getPopularTvSeries();

          verify(mockRemoteDataSource.getPopularTvSeries());

          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvSeriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          when(mockRemoteDataSource.getPopularTvSeries())
              .thenThrow(ServerException());

          final result = await repository.getPopularTvSeries();

          verify(mockRemoteDataSource.getPopularTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(SocketException('Failed to connect to network'));

      final result = await repository.getPopularTvSeries();

      verify(mockRemoteDataSource.getPopularTvSeries());
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Top Rated Tv Series', () {
    test(
        'should return remote data when the call remote data source is successful',
            () async {
          when(mockRemoteDataSource.getTopRateTvSeries())
              .thenAnswer((_) async => tTvSeriesModelList);

          final result = await repository.getTopRatedTvSeries();

          verify(mockRemoteDataSource.getTopRateTvSeries());

          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvSeriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          when(mockRemoteDataSource.getTopRateTvSeries())
              .thenThrow(ServerException());

          final result = await repository.getTopRatedTvSeries();

          verify(mockRemoteDataSource.getTopRateTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getTopRateTvSeries())
          .thenThrow(SocketException('Failed to connect to network'));

      final result = await repository.getTopRatedTvSeries();

      verify(mockRemoteDataSource.getTopRateTvSeries());
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Airing Today Tv Series', () {
    test(
        'should return remote data when the call remote data source is successful',
            () async {
          when(mockRemoteDataSource.getAiringTodayTvSeries())
              .thenAnswer((_) async => tTvSeriesModelList);

          final result = await repository.getAiringTodayTvSeries();

          verify(mockRemoteDataSource.getAiringTodayTvSeries());

          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvSeriesList);
        });

    test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          when(mockRemoteDataSource.getAiringTodayTvSeries())
              .thenThrow(ServerException());

          final result = await repository.getAiringTodayTvSeries();

          verify(mockRemoteDataSource.getAiringTodayTvSeries());
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getAiringTodayTvSeries())
          .thenThrow(SocketException('Failed to connect to network'));

      final result = await repository.getAiringTodayTvSeries();

      verify(mockRemoteDataSource.getAiringTodayTvSeries());
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('Get Tv Series Detail', () {
    final tId = 1;
    final tTvSeriesDetailResponse = TvSeriesDetailResponse(
        backdropPath: 'backdropPath',
        genres: [GenreModel(id: 1, name: 'Action')],
        homepage: 'homepage',
        id: 1,
        originalLanguage: 'originalLanguage',
        originalName: 'originalName',
        overview: 'overview',
        popularity: 1,
        posterPath: 'posterPath',
        firstAirDate: 'firstAirDate',
        status: 'status',
        tagline: 'tagline',
        name: 'name',
        voteAverage: 1,
        voteCount: 1);

    test(
        'should return Movie data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesDetail(tId))
              .thenAnswer((_) async => tTvSeriesDetailResponse);
          // act
          final result = await repository.getTvSeriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesDetail(tId));
          expect(result, equals(Right(testTvSeriesDetail)));
        });

    test(
        'should return Server Failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesDetail(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvSeriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesDetail(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesDetail(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvSeriesDetail(tId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesDetail(tId));
          expect(result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('Get Tv Series Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    final tId = 1;

    test('should return data (tv series list) when the call is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
              .thenAnswer((_) async => tTvSeriesList);
          // act
          final result = await repository.getTvSeriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));

          final resultList = result.getOrElse(() => []);
          expect(resultList, equals(tTvSeriesList));
        });

    test(
        'should return server failure when call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
              .thenThrow(ServerException());
          // act
          final result = await repository.getTvSeriesRecommendations(tId);
          // assertbuild runner
          verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
          expect(result, equals(Left(ServerFailure(''))));
        });

    test(
        'should return connection failure when the device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.getTvSeriesRecommendations(tId);
          // assert
          verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
          expect(result,
              equals(
                  Left(ConnectionFailure('Failed to connect to the network'))));
        });
  });

  group('save tv series watchlist', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertTvSeriesWatchList(testMovieTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.saveTvSeriesWatchlist(testTvSeriesDetailForLocal);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertTvSeriesWatchList(testMovieTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.saveTvSeriesWatchlist(testTvSeriesDetailForLocal);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove tv series watchlist', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeTvSeriesWatchList(testTvSeriesDetailForLocal);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeWatchlist(testMovieTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeTvSeriesWatchList(testTvSeriesDetailForLocal);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('Seach Tv Series', () {
    final tQuery = 'name';

    test('should return tv series list when call to data source is successful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenAnswer((_) async => tTvSeriesModelList);
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          final resultList = result.getOrElse(() => []);
          expect(resultList, tTvSeriesList);
        });

    test('should return ServerFailure when call to data source is unsuccessful',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          expect(result, Left(ServerFailure('')));
        });

    test(
        'should return ConnectionFailure when device is not connected to the internet',
            () async {
          // arrange
          when(mockRemoteDataSource.searchTvSeries(tQuery))
              .thenThrow(SocketException('Failed to connect to the network'));
          // act
          final result = await repository.searchTvSeries(tQuery);
          // assert
          expect(
              result,
              Left(ConnectionFailure('Failed to connect to the network')));
        });
  });
}
