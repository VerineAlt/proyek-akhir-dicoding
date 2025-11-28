import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';

final testTvSeriesDetail = TvSeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  firstAirDate: '2022-01-01',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  lastAirDate: '2022-01-01',
  lastEpisodeToAir: EpisodeToAir(
    id: 1,
    name: 'name',
    overview: 'overview',
    airDate: 'airDate',
    episodeNumber: 1,
    seasonNumber: 1,
    stillPath: 'stillPath',
    runtime: 1,
  ),
  name: 'name',
  nextEpisodeToAir: null,
  numberOfEpisodes: 1,
  numberOfSeasons: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [
    Season(
      airDate: 'airDate',
      episodeCount: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 1,
    )
  ],
  status: 'status',
  tagline: 'tagline',
  voteAverage: 1,
  voteCount: 1,
);
final testTvSeries = TvSeries(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2020-05-05',
    name: 'TV Name',
    voteAverage: 1.0,
    voteCount: 1,
  );

final testMovie = Movie(
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

final testMovieList = [testMovie];


final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: '2023-01-01', 
  runtime: 120,
  title: 'title',
  voteAverage: 1.0,
  voteCount: 1,
  budget: 100000000, 
  homepage: 'https://www.example.com', 
  imdbId: 'tt1234567', 
  originalLanguage: 'en', 
  popularity: 90.5, 
  
);

final testMovieDetailResponse = MovieDetailResponse(
  adult: false,
  backdropPath: 'backdropPath',
  budget: 100000000,
  genres: [GenreModel(id: 1, name: 'Action')],
  homepage: 'https://www.example.com',
  id: 1,
  imdbId: 'tt1234567',
  originalLanguage: 'en',
  originalTitle: 'originalTitle',
  overview: 'overview',
  popularity: 90.5,
  posterPath: 'posterPath',
  releaseDate: '2023-01-01',
  revenue: 200000000,
  runtime: 120,
  status: 'Released',
  tagline: 'tagline',
  title: 'title',
  video: false,
  voteAverage: 1.0,
  voteCount: 1,
);

final testMovieDetailMap = {
  "adult": false,
  "backdrop_path": "backdropPath",
  "budget": 100000000,
  "genres": [
    {"id": 1, "name": "Action"}
  ],
  "homepage": "https://www.example.com",
  "id": 1,
  "imdb_id": "tt1234567",
  "original_language": "en",
  "original_title": "originalTitle",
  "overview": "overview",
  "popularity": 90.5,
  "poster_path": "posterPath",
  "release_date": "2023-01-01",
  "revenue": 200000000,
  "runtime": 120,
  "status": "Released",
  "tagline": "tagline",
  "title": "title",
  "video": false,
  "vote_average": 1.0,
  "vote_count": 1
};
