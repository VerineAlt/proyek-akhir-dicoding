import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  // 1. Nested Models
  final tSeasonModel = SeasonModel(
    airDate: '2024-01-01',
    episodeCount: 10,
    id: 1,
    name: 'Season 1',
    overview: 'Overview',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  final tLastEpisodeModel = LastEpisodeToAirModel(
    id: 1,
    name: 'Episode 1',
    overview: 'Overview',
    airDate: '2024-01-01',
    episodeNumber: 1,
    seasonNumber: 1,
    stillPath: '/path.jpg',
    runtime: 60,
  );

  // 2. Main Model
  final tTvSeriesDetailModel = TvSeriesDetailModel(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2024-01-01',
    genres: [GenreModel(id: 1, name: 'Action')],
    homepage: 'https://google.com',
    id: 1,
    inProduction: true,
    lastAirDate: '2024-02-01',
    lastEpisodeToAir: tLastEpisodeModel,
    name: 'TV Series Title',
    nextEpisodeToAir: null,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalLanguage: 'en',
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 10.0,
    posterPath: '/poster.jpg',
    seasons: [tSeasonModel],
    status: 'Returning Series',
    tagline: 'Tagline',
    type: 'Scripted',
    voteAverage: 8.5,
    voteCount: 100,
  );

  // 3. Expected Entity
  final tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: '/backdrop.jpg',
    firstAirDate: '2024-01-01',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    lastAirDate: '2024-02-01',
    lastEpisodeToAir: tLastEpisodeModel.toEntity(),
    name: 'TV Series Title',
    nextEpisodeToAir: null,
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    overview: 'Overview',
    posterPath: '/poster.jpg',
    seasons: [tSeasonModel.toEntity()],
    status: 'Returning Series',
    tagline: 'Tagline',
    voteAverage: 8.5,
    voteCount: 100,
  );

  // 4. JSON Map
  final tJson = {
    "adult": false,
    "backdrop_path": "/backdrop.jpg",
    "first_air_date": "2024-01-01",
    "genres": [
      {"id": 1, "name": "Action"}
    ],
    "homepage": "https://google.com",
    "id": 1,
    "in_production": true,
    "last_air_date": "2024-02-01",
    "last_episode_to_air": {
      "id": 1,
      "name": "Episode 1",
      "overview": "Overview",
      "air_date": "2024-01-01",
      "episode_number": 1,
      "season_number": 1,
      "still_path": "/path.jpg",
      "runtime": 60
    },
    "name": "TV Series Title",
    "next_episode_to_air": null,
    "number_of_episodes": 10,
    "number_of_seasons": 1,
    "original_language": "en",
    "original_name": "Original Name",
    "overview": "Overview",
    "popularity": 10.0,
    "poster_path": "/poster.jpg",
    "seasons": [
      {
        "air_date": "2024-01-01",
        "episode_count": 10,
        "id": 1,
        "name": "Season 1",
        "overview": "Overview",
        "poster_path": "/path.jpg",
        "season_number": 1
      }
    ],
    "status": "Returning Series",
    "tagline": "Tagline",
    "type": "Scripted",
    "vote_average": 8.5,
    "vote_count": 100
  };

  group('TvSeriesDetailModel', () {
    test('should parse from JSON correctly', () {
      // act
      final result = TvSeriesDetailModel.fromJson(tJson);
      // assert
      expect(result, tTvSeriesDetailModel);
    });

    test('should convert to Entity correctly', () {
      // act
      final result = tTvSeriesDetailModel.toEntity();
      // assert
      expect(result, tTvSeriesDetail);
    });
  });
  
  // Optional: Add tests for Nested models if you want to be thorough
  group('SeasonModel', () {
    test('should convert to Entity correctly', () {
      final result = tSeasonModel.toEntity();
      expect(result, isA<Season>());
    });
  });
}