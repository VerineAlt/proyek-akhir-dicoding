import 'package:ditonton/domain/entities/genre.dart'; 
import 'package:equatable/equatable.dart';

// FIX: Extend Equatable and define props
class EpisodeToAir extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String airDate;
  final int episodeNumber;
  final int seasonNumber;
  final String? stillPath;
  final int? runtime;

  EpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.airDate,
    required this.episodeNumber,
    required this.seasonNumber,
    required this.stillPath,
    required this.runtime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        airDate,
        episodeNumber,
        seasonNumber,
        stillPath,
        runtime,
      ];
}

// FIX: Extend Equatable and define props
class Season extends Equatable {
  final String? airDate; // Changed to nullable based on typical API response/usage
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });
  
  @override
  List<Object?> get props => [
        airDate,
        episodeCount,
        id,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}

class TvSeriesDetail extends Equatable {
  TvSeriesDetail({
    required this.adult,
    required this.backdropPath,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name, // Main Title
    required this.nextEpisodeToAir,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.overview,
    required this.posterPath,
    required this.seasons, // For Optional Criteria
    required this.status,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String? backdropPath;
  final String firstAirDate;
  final List<Genre> genres; 
  final int id;
  final String lastAirDate;
  final EpisodeToAir lastEpisodeToAir; // Now correctly compared
  final String name;
  final EpisodeToAir? nextEpisodeToAir;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final String overview;
  final String? posterPath;
  final List<Season> seasons; // Now correctly compared
  final String status;
  final String tagline;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAirDate,
        genres,
        id,
        lastAirDate,
        lastEpisodeToAir, // CRITICAL: Comparison now works
        name,
        nextEpisodeToAir, // CRITICAL: Comparison now works
        numberOfEpisodes,
        numberOfSeasons,
        overview,
        posterPath,
        seasons, // CRITICAL: Comparison now works for the list
        status,
        tagline,
        voteAverage,
        voteCount
      ];
}