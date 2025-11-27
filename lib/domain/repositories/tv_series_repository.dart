import 'package:dartz/dartz.dart'; // Assuming you use dartz for functional error handling
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

abstract class TvSeriesRepository {
  // --- Criteria 1: List TV Series ---

  /// Fetches the list of TV series currently airing today.
  Future<Either<Failure, List<TvSeries>>> getAiringTodayTvSeries();

  /// Fetches the list of popular TV series.
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();

  /// Fetches the list of top-rated TV series.
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();

  // --- Criteria 2: Detail TV Series ---

  /// Fetches the detailed information for a specific TV series ID.
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id);

  /// Fetches a list of recommended TV series based on a specific ID.
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(int id);

  // --- Criteria 3: Search TV Series ---

  /// Searches for TV series based on a user-provided query string.
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query);

  // --- Criteria 4: Watchlist ---

  /// Saves a TV series entity to the local watchlist database.
  Future<Either<Failure, String>> saveWatchlistTv(TvSeriesDetail tvSeries);

  /// Removes a TV series entity from the local watchlist database.
  Future<Either<Failure, String>> removeWatchlistTv(TvSeriesDetail tvSeries);

  /// Gets the status (is it on the watchlist?) for a specific TV series ID.
  Future<Either<Failure, bool>> isAddedToWatchlistTv(int id);

  /// Retrieves the entire list of TV series entities from the watchlist.
  Future<Either<Failure, List<TvSeries>>> getWatchlistTv();
}
