import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart'; // Ensure testTvSeriesDetail is here
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Name',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    firstAirDate: '2002-05-01',
    name: 'Name',
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  // --- 1. GET AIRING TODAY ---
  group('Airing Today TV Series', () {
    test('should return remote data when the call to remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.getAiringTodayTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      // act
      final result = await repository.getAiringTodayTvSeries();
      // assert
      verify(mockRemoteDataSource.getAiringTodayTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(mockRemoteDataSource.getAiringTodayTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getAiringTodayTvSeries();
      // assert
      verify(mockRemoteDataSource.getAiringTodayTvSeries());
      expect(result, equals(Left(ServerFailure('Failed to connect to the server.'))));
    });

    test('should return connection failure when the device is not connected to internet', () async {
      // arrange
      when(mockRemoteDataSource.getAiringTodayTvSeries())
          .thenThrow(SocketException('Failed to connect to the network.'));
      // act
      final result = await repository.getAiringTodayTvSeries();
      // assert
      verify(mockRemoteDataSource.getAiringTodayTvSeries());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network.'))));
    });
  });

  // --- 2. GET POPULAR ---
  group('Popular TV Series', () {
    test('should return remote data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getPopularTvSeries();
      verify(mockRemoteDataSource.getPopularTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getPopularTvSeries();
      verify(mockRemoteDataSource.getPopularTvSeries());
      expect(result, equals(Left(ServerFailure('Failed to connect to the server.'))));
    });

    test('should return connection failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getPopularTvSeries())
          .thenThrow(SocketException('Failed to connect to the network.'));
      final result = await repository.getPopularTvSeries();
      verify(mockRemoteDataSource.getPopularTvSeries());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network.'))));
    });
  });

  // --- 3. GET TOP RATED ---
  group('Top Rated TV Series', () {
    test('should return remote data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.getTopRatedTvSeries();
      verify(mockRemoteDataSource.getTopRatedTvSeries());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when the call to remote data source is unsuccessful', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      final result = await repository.getTopRatedTvSeries();
      verify(mockRemoteDataSource.getTopRatedTvSeries());
      expect(result, equals(Left(ServerFailure('Failed to connect to the server.'))));
    });

    test('should return connection failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(SocketException('Failed to connect to the network.'));
      final result = await repository.getTopRatedTvSeries();
      verify(mockRemoteDataSource.getTopRatedTvSeries());
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network.'))));
    });
  });

  // --- 4. GET DETAIL ---
  group('Get TV Series Detail', () {
    final tId = 1;
    final tTvSeriesResponse = TvSeriesDetailModel(
      adult: false,
      backdropPath: 'backdropPath',
      firstAirDate: '2022-01-01',
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: "https://google.com",
      id: 1,
      inProduction: false,
      lastAirDate: '2022-01-01',
      lastEpisodeToAir: LastEpisodeToAirModel(
        id: 1, name: 'name', overview: 'overview', airDate: 'airDate', 
        episodeNumber: 1, seasonNumber: 1, stillPath: 'stillPath', runtime: 1),
      name: 'name',
      nextEpisodeToAir: null,
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originalLanguage: 'en',
      originalName: 'originalName',
      overview: 'overview',
      popularity: 1,
      posterPath: 'posterPath',
      seasons: [
        SeasonModel(airDate: 'airDate', episodeCount: 1, id: 1, name: 'name', overview: 'overview', posterPath: 'posterPath', seasonNumber: 1)
      ],
      status: 'Status',
      tagline: 'Tagline',
      type: 'Type',
      voteAverage: 1,
      voteCount: 1,
    );

    test('should return Movie Detail data when the call to remote data source is successful', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenAnswer((_) async => tTvSeriesResponse);
      final result = await repository.getTvSeriesDetail(tId);
      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Right(testTvSeriesDetail)));
    });

    test('should return Server Failure when the call to remote data source is unsuccessful', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(ServerException());
      final result = await repository.getTvSeriesDetail(tId);
      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ServerFailure('Failed to connect to the server.'))));
    });

    test('should return Connection Failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getTvSeriesDetail(tId))
          .thenThrow(SocketException('Failed to connect to the network.'));
      final result = await repository.getTvSeriesDetail(tId);
      verify(mockRemoteDataSource.getTvSeriesDetail(tId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network.'))));
    });
  });

  // --- 5. GET RECOMMENDATIONS ---
  group('Get TV Series Recommendations', () {
    final tTvSeriesList = <TvSeriesModel>[];
    final tId = 1;

    test('should return data (movie list) when the call is successful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenAnswer((_) async => tTvSeriesList);
      final result = await repository.getTvSeriesRecommendations(tId);
      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvSeriesList));
    });

    test('should return server failure when call to remote data source is unsuccessful', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getTvSeriesRecommendations(tId);
      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      expect(result, equals(Left(ServerFailure('Failed to connect to the server.'))));
    });

    test('should return connection failure when the device is not connected to internet', () async {
      when(mockRemoteDataSource.getTvSeriesRecommendations(tId))
          .thenThrow(SocketException('Failed to connect to the network.'));
      final result = await repository.getTvSeriesRecommendations(tId);
      verify(mockRemoteDataSource.getTvSeriesRecommendations(tId));
      expect(result, equals(Left(ConnectionFailure('Failed to connect to the network.'))));
    });
  });

  // --- 6. SEARCH ---
  group('Seach TV Series', () {
    final tQuery = 'spiderman';

    test('should return movie list when call to data source is successful', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenAnswer((_) async => tTvSeriesModelList);
      final result = await repository.searchTvSeries(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return server failure when call to data source is unsuccessful', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(ServerException());
      final result = await repository.searchTvSeries(tQuery);
      expect(result, Left(ServerFailure('Failed to connect to the server.')));
    });

    test('should return connection failure when device is not connected to internet', () async {
      when(mockRemoteDataSource.searchTvSeries(tQuery))
          .thenThrow(SocketException('Failed to connect to the network.'));
      final result = await repository.searchTvSeries(tQuery);
      expect(result, Left(ConnectionFailure('Failed to connect to the network.')));
    });
  });

  // --- 7. SAVE WATCHLIST ---
  group('Save Watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertWatchlist(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlistTv(testTvSeriesDetail);
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertWatchlist(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlistTv(testTvSeriesDetail);
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  // --- 8. REMOVE WATCHLIST ---
  group('Remove Watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeWatchlist(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenAnswer((_) async => 'Removed from watchlist');
      final result = await repository.removeWatchlistTv(testTvSeriesDetail);
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeWatchlist(TvSeriesTable.fromEntity(testTvSeriesDetail)))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlistTv(testTvSeriesDetail);
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  // --- 9. GET STATUS ---
  group('Get Watchlist Status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getTvSeriesById(tId)).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlistTv(tId);
      expect(result, Right(false));
    });

    test('should return true when data is found', () async {
      final tId = 1;
      when(mockLocalDataSource.getTvSeriesById(tId)).thenAnswer((_) async => testTvSeriesMap);
      final result = await repository.isAddedToWatchlistTv(tId);
      expect(result, Right(true));
    });
  });

  // --- 10. GET WATCHLIST LIST ---
  group('Get Watchlist TV Series', () {
    test('should return list of TV Series', () async {
      when(mockLocalDataSource.getWatchlistTv())
          .thenAnswer((_) async => [testTvSeriesMap]);
      final result = await repository.getWatchlistTv();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}