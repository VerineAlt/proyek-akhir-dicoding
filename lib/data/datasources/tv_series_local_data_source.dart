import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/models/tv_series_table.dart'; // Import your new TV Series Table model

// Define the contract (Interface)
abstract class TvSeriesLocalDataSource {
  Future<String> insertWatchlist(TvSeriesTable tvSeries);
  Future<String> removeWatchlist(TvSeriesTable tvSeries);
  Future<TvSeriesTable?> getTvSeriesById(int id);
  Future<List<TvSeriesTable>> getWatchlistTv();
}

// Implement the contract
class TvSeriesLocalDataSourceImpl implements TvSeriesLocalDataSource {
  // Assume DatabaseHelper is generic enough to handle both Movie and TV Series tables
  final DatabaseHelper databaseHelper; 

  TvSeriesLocalDataSourceImpl({required this.databaseHelper});

  // --- 1. INSERT WATCHLIST ---
  @override
  Future<String> insertWatchlist(TvSeriesTable tvSeries) async {
    try {
      // Assuming DatabaseHelper has a method to handle TV Series (or a generic insert)
      await databaseHelper.insertWatchlistTv(tvSeries); 
      return 'Added to Watchlist';
    } catch (e) {
      // Catches errors during database operation
      throw DatabaseException(e.toString());
    }
  }

  // --- 2. REMOVE WATCHLIST ---
  @override
  Future<String> removeWatchlist(TvSeriesTable tvSeries) async {
    try {
      // Assuming DatabaseHelper has a method to handle TV Series
      await databaseHelper.removeWatchlistTv(tvSeries); 
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  // --- 3. GET BY ID ---
  @override
  Future<TvSeriesTable?> getTvSeriesById(int id) async {
    // Assuming DatabaseHelper has a method specifically for TV Series
    final result = await databaseHelper.getTvSeriesById(id); 
    
    if (result != null) {
      // Use the TvSeriesTable's fromMap factory
      return TvSeriesTable.fromMap(result); 
    } else {
      return null;
    }
  }

  // --- 4. GET ALL WATCHLIST TV SERIES ---
  @override
  Future<List<TvSeriesTable>> getWatchlistTv() async {
    // Assuming DatabaseHelper has a method for getting all TV Series
    final result = await databaseHelper.getWatchlistTv(); 
    
    // Map the list of raw data back to TvSeriesTable objects
    return result.map((data) => TvSeriesTable.fromMap(data)).toList();
  }
}