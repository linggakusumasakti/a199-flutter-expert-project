import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class TvSeriesModel extends Equatable {
  TvSeriesModel(
      {required this.backdropPath,
      required this.genreIds,
      required this.id,
      required this.name,
      required this.overview,
      required this.popularity,
      required this.posterPath,
      required this.firstAirDate,
      required this.voteAverage,
      required this.voteCount});

  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? firstAirDate;
  final double voteAverage;
  final int voteCount;

  factory TvSeriesModel.fromJson(Map<String, dynamic> json) => TvSeriesModel(
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        firstAirDate: json["first_air_date"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toJson() => {
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "name": name,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "first_air_date": firstAirDate,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  TvSeries toEntity() {
    return TvSeries(
        backdropPath: backdropPath,
        genreIds: genreIds,
        id: id,
        name: name,
        overview: overview,
        popularity: popularity,
        posterPath: posterPath,
        firstAirDate: firstAirDate,
        voteAverage: voteAverage,
        voteCount: voteCount);
  }

  @override
  List<Object?> get props => [
        backdropPath,
        genreIds,
        id,
        name,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        voteAverage,
        voteCount,
      ];
}
