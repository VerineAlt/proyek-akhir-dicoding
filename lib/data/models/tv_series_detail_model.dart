import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

// --- 1. Nested Model: LastEpisodeToAirModel ---
// Used for 'last_episode_to_air' and 'next_episode_to_air'
class LastEpisodeToAirModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String? airDate; // Can be null in 'next_episode_to_air'
  final int episodeNumber;
  final int seasonNumber;
  final String? stillPath;
  final int? runtime; // Can be null

  LastEpisodeToAirModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.airDate,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.stillPath,
    required this.runtime,
  });

  factory LastEpisodeToAirModel.fromJson(Map<String, dynamic> json) =>
      LastEpisodeToAirModel(
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        airDate: json['air_date'],
        episodeNumber: json['episode_number'],
        seasonNumber: json['season_number'],
        stillPath: json['still_path'],
        runtime: json['runtime'],
      );

  // Conversion to Domain Entity
  EpisodeToAir toEntity() {
    return EpisodeToAir(
      id: this.id,
      name: this.name,
      overview: this.overview,
      airDate: this.airDate ?? '',
      episodeNumber: this.episodeNumber,
      seasonNumber: this.seasonNumber,
      stillPath: this.stillPath,
      runtime: this.runtime,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        airDate,
        episodeNumber,
        seasonNumber,
        stillPath,
        runtime
      ];
}

// --- 2. Nested Model: SeasonModel ---
class SeasonModel extends Equatable {
  final String? airDate; // Can be null
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  SeasonModel({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        airDate: json['air_date'],
        episodeCount: json['episode_count'],
        id: json['id'],
        name: json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        seasonNumber: json['season_number'],
      );

  // Conversion to Domain Entity
  Season toEntity() {
    return Season(
      airDate: this.airDate ?? '',
      episodeCount: this.episodeCount,
      id: this.id,
      name: this.name,
      overview: this.overview,
      posterPath: this.posterPath,
      seasonNumber: this.seasonNumber,
    );
  }

  @override
  List<Object?> get props =>
      [airDate, episodeCount, id, name, overview, posterPath, seasonNumber];
}

// --- 3. Main Detail Model: TvSeriesDetailModel ---
class TvSeriesDetailModel extends Equatable {
  TvSeriesDetailModel({
    required this.adult,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.seasons,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final String? firstAirDate; // Made nullable to handle edge cases
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final String? lastAirDate; // Made nullable to handle edge cases
  final LastEpisodeToAirModel lastEpisodeToAir;
  final String name;
  final LastEpisodeToAirModel? nextEpisodeToAir; // Can be null
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final List<SeasonModel> seasons;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  factory TvSeriesDetailModel.fromJson(Map<String, dynamic> json) =>
      TvSeriesDetailModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        firstAirDate: json["first_air_date"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        inProduction: json["in_production"],
        lastAirDate: json["last_air_date"],
        lastEpisodeToAir:
            LastEpisodeToAirModel.fromJson(json["last_episode_to_air"]),
        name: json["name"],
        nextEpisodeToAir: json["next_episode_to_air"] != null
            ? LastEpisodeToAirModel.fromJson(json["next_episode_to_air"])
            : null,
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        seasons: List<SeasonModel>.from(
            json["seasons"].map((x) => SeasonModel.fromJson(x))),
        status: json["status"],
        tagline: json["tagline"],
        type: json["type"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  // --- Conversion to Domain Entity ---
  TvSeriesDetail toEntity() {
    return TvSeriesDetail(
      adult: this.adult,
      backdropPath: this.backdropPath,
      firstAirDate: this.firstAirDate ?? '',
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      lastAirDate: this.lastAirDate ?? '',
      lastEpisodeToAir: this.lastEpisodeToAir.toEntity(),
      name: this.name,
      nextEpisodeToAir: this.nextEpisodeToAir?.toEntity(),
      numberOfEpisodes: this.numberOfEpisodes,
      numberOfSeasons: this.numberOfSeasons,
      overview: this.overview,
      posterPath: this.posterPath,
      seasons: this.seasons.map((season) => season.toEntity()).toList(),
      status: this.status,
      tagline: this.tagline,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
    );
  }

  // --- toJson method (Useful for local storage/testing) ---
  Map<String, dynamic> toJson() => {
        // Implement toJson fully if needed for local storage/watchlist detail
        // For now, focusing on the toEntity path.
      };

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAirDate,
        genres,
        homepage,
        id,
        inProduction,
        lastAirDate,
        lastEpisodeToAir,
        name,
        nextEpisodeToAir,
        numberOfEpisodes,
        numberOfSeasons,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        seasons,
        status,
        tagline,
        type,
        voteAverage,
        voteCount
      ];
}
