import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart'; // Must create this
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart'; // Already created
import 'package:ditonton/data/models/tv_series_table.dart'; // Must create this
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart'; // Already created

class TvSeriesRepositoryImpl implements TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource; // For Watchlist

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // --- 1. GET AIRING TODAY TV SERIES ---
  @override
  Future<Either<Failure, List<TvSeries>>> getAiringTodayTvSeries() async {
    try {
      final result = await remoteDataSource.getAiringTodayTvSeries();
      // Map the List of Models to a List of Domain Entities
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server.'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network.'));
    }
  }

  // --- 2. GET POPULAR TV SERIES ---
  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async {
    try {
      final result = await remoteDataSource.getPopularTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server.'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network.'));
    }
  }

  // --- 3. GET TOP RATED TV SERIES ---
  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async {
    try {
      final result = await remoteDataSource.getTopRatedTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server.'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network.'));
    }
  }

  // --- 4. GET TV SERIES DETAIL ---
  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesDetail(id);
      // Map the Detail Model to the Detail Domain Entity
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server.'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network.'));
    }
  }

  // --- 5. GET TV SERIES RECOMMENDATIONS ---
  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
      int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server.'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network.'));
    }
  }

  // --- 6. SEARCH TV SERIES ---
  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    try {
      final result = await remoteDataSource.searchTvSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure('Failed to connect to the server.'));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network.'));
    }
  }

  // --- WATCHLIST IMPLEMENTATION (Criteria 4) ---

  @override
  Future<Either<Failure, String>> removeWatchlistTv(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource
          .removeWatchlist(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isAddedToWatchlistTv(int id) async {
    try {
      final result = await localDataSource.getTvSeriesById(id);
      // If result is not null, it's on the watchlist
      return Right(result != null);
    } catch (e) {
      // If an error occurs (e.g., table doesn't exist yet), assume it's not added.
      return Left(DatabaseFailure('Error checking watchlist status.'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTv() async {
    final result = await localDataSource.getWatchlistTv();
    // Map the List of Watchlist Table Models back to Domain Entities
    return Right(result.map((model) => model.toEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> saveWatchlistTv(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource
          .insertWatchlist(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }
}
