import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

class MovieTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int isMovie;

  MovieTable(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.overview,
      required this.isMovie});

  factory MovieTable.fromEntity(MovieDetail movie) => MovieTable(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      isMovie: movie.isMovie);

  factory MovieTable.fromEntityTvSeries(TvSeriesDetail tvSeries) => MovieTable(
      id: tvSeries.id,
      title: tvSeries.name,
      posterPath: tvSeries.posterPath,
      overview: tvSeries.overview,
      isMovie: tvSeries.isMovie);

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        isMovie: map['isMovie'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'isMovie': isMovie
      };

  Movie toEntity() => Movie.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
        isMovie: isMovie,
      );

  TvSeries toEntityTvSeries() => TvSeries.watchList(
      id: id, overview: overview, posterPath: posterPath, name: title);

  @override
  // TODO: implement props
  List<Object?> get props => [id, title, posterPath, overview];
}
