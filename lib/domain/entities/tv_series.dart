import 'package:equatable/equatable.dart';

class TvSeries extends Equatable {
  TvSeries({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.firstAirDate,
    required this.name,
    required this.voteAverage,
    required this.voteCount,
  });

  // Watchlist constructor for minimal data
  TvSeries.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name, // Watchlist items need the name
  });

  bool? adult;
  String? backdropPath;
  List<int>? genreIds;
  int id;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  String? firstAirDate;
  String? name; // This replaces 'title' in the Movie entity
  double? voteAverage;
  int? voteCount;

  @override
  // TODO: implement props
  List<Object?> get props => [
        adult,
        backdropPath,
        genreIds,
        id,
        originalName,
        overview,
        popularity,
        posterPath,
        firstAirDate,
        name,
        voteAverage,
        voteCount
      ];

  // @override List<Object?> get props should be fully implemented here.
}
