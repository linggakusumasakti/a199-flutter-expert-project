import 'package:equatable/equatable.dart';

import 'genre.dart';

class TvSeriesDetail extends Equatable {
  TvSeriesDetail(
      {required this.backdropPath,
      required this.genres,
      required this.homepage,
      required this.id,
      required this.originalLanguage,
      required this.originalName,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.firstAirDate,
      required this.status,
      required this.tagline,
      required this.name,
      required this.voteAverage,
      required this.voteCount});

  final String? backdropPath;
  final List<Genre> genres;
  final String homepage;
  final int id;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final String firstAirDate;
  final String status;
  final String tagline;
  final String name;
  final double voteAverage;
  final int voteCount;
  final int isMovie = 0;

  @override
  List<Object?> get props => [
        backdropPath,
        genres,
        homepage,
        id,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        status,
        tagline,
        name,
        voteAverage,
        voteCount
      ];
}
