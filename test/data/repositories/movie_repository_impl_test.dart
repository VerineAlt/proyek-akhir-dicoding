import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart'; // Ensure this contains testMovieDetail, testMovie, etc.
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
    overview: 'After being bitten by a genetically altered spider...',
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
    overview: 'After being bitten by a genetically altered spider...',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  // --- 1. GET NOW PLAYING (Already covered, but keeping for completeness) ---
  group('Now Playing Movies', () {
    test('should return remote data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.getNowPlayingMovies();
      verify(mockRemoteDataSource.getNowPlayingMovies());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return server failure when call to remote data source is unsuccessful', () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(ServerException());
      final result = await repository.getNowPlayingMovies();
      verify(mockRemoteDataSource.getNowPlayingMovies());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when device is not connected to internet', () async {
      when(mockRemoteDataSource.getNowPlayingMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getNowPlayingMovies();
      verify(mockRemoteDataSource.getNowPlayingMovies());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  // --- 2. GET POPULAR MOVIES ---
  group('Popular Movies', () {
    test('should return movie list when call to data source is success', () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.getPopularMovies();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(ServerException());
      final result = await repository.getPopularMovies();
      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure when device is not connected to internet', () async {
      when(mockRemoteDataSource.getPopularMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getPopularMovies();
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  // --- 3. GET TOP RATED MOVIES ---
  group('Top Rated Movies', () {
    test('should return movie list when call to data source is success', () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.getTopRatedMovies();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(ServerException());
      final result = await repository.getTopRatedMovies();
      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure when device is not connected to internet', () async {
      when(mockRemoteDataSource.getTopRatedMovies())
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getTopRatedMovies();
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  // --- 4. GET MOVIE DETAIL ---
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
      releaseDate: '2023-01-01',
      revenue: 12000,
      runtime: 120,
      status: 'Status',
      tagline: 'Tagline',
      title: 'title',
      video: false,
      voteAverage: 1,
      voteCount: 1,
    );

    test('should return Movie Detail data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenAnswer((_) async => tMovieResponse);
      final result = await repository.getMovieDetail(tId);
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Right(testMovieDetail)));
    });

    test('should return Server Failure when the call to remote data source is unsuccessful', () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(ServerException());
      final result = await repository.getMovieDetail(tId);
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return Connection Failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getMovieDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getMovieDetail(tId);
      verify(mockRemoteDataSource.getMovieDetail(tId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  // --- 5. GET MOVIE RECOMMENDATIONS ---
  group('Get Movie Recommendations', () {
    final tMovieList = <MovieModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful', () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenAnswer((_) async => tMovieList);
      final result = await repository.getMovieRecommendations(tId);
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tMovieList));
    });

    test('should return server failure when call to remote data source is unsuccessful', () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getMovieRecommendations(tId);
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return connection failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getMovieRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.getMovieRecommendations(tId);
      verify(mockRemoteDataSource.getMovieRecommendations(tId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  // --- 6. SEARCH MOVIES ---
  group('Seach Movies', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful', () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieModelList);
      final result = await repository.searchMovies(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tMovieList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(ServerException());
      final result = await repository.searchMovies(tQuery);
      expect(result, Left(ServerFailure('')));
    });

    test('should return connection failure when device is not connected to internet', () async {
      when(mockRemoteDataSource.searchMovies(tQuery))
          .thenThrow(SocketException('Failed to connect to the network'));
      final result = await repository.searchMovies(tQuery);
      expect(result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  // --- 7. SAVE WATCHLIST ---
  group('Save Watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(MovieTable.fromEntity(testMovieDetail)))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testMovieDetail);
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlist(MovieTable.fromEntity(testMovieDetail)))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testMovieDetail);
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  // --- 8. REMOVE WATCHLIST ---
  group('Remove Watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(MovieTable.fromEntity(testMovieDetail)))
          .thenAnswer((_) async => 'Removed from watchlist');
      final result = await repository.removeWatchlist(testMovieDetail);
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlist(MovieTable.fromEntity(testMovieDetail)))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testMovieDetail);
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  // --- 9. GET WATCHLIST STATUS (isAddedToWatchlist) ---
  group('Get Watchlist Status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, Right(false));
    });

    test('should return true when data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenAnswer((_) async => testMovieMap);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, Right(true));
    });

    // New coverage for line 124 (Catch block)
    test('should return DatabaseFailure when error occurs', () async {
      final tId = 1;
      when(mockLocalDataSource.getMovieById(tId)).thenThrow(DatabaseException('Error'));
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, Left(DatabaseFailure(DatabaseException('Error').toString()))); // Adjust message based on e.toString()
    });
  });

  // --- 10. GET WATCHLIST MOVIES ---
  group('Get Watchlist Movies', () {
    test('should return list of Movies', () async {
      when(mockLocalDataSource.getWatchlistMovies())
          .thenAnswer((_) async => [testMovieMap]);
      final result = await repository.getWatchlistMovies();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistMovie]);
    });
  });
}