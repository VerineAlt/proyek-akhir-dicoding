import 'package:ditonton/domain/entities/tv_series.dart'; // Use TV Series Entity
import 'package:ditonton/domain/entities/tv_series_detail.dart'; // Use TV Series Detail Entity
import 'package:equatable/equatable.dart';

class TvSeriesTable extends Equatable {
  final int id;
  final String? name; // Use 'name' for TV Series title
  final String? posterPath;
  final String? overview;

  TvSeriesTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  // --- 1. From Domain Entity (Detail) to Table ---
  // Used when adding a TV Series to the Watchlist (from the Detail Page)
  factory TvSeriesTable.fromEntity(TvSeriesDetail tvSeries) => TvSeriesTable(
        id: tvSeries.id,
        name: tvSeries.name,
        posterPath: tvSeries.posterPath,
        overview: tvSeries.overview,
      );

  // Note: If you also want to save from the general TvSeries entity, you need another factory:
  /*
  factory TvSeriesTable.fromWatchlistEntity(TvSeries tvSeries) => TvSeriesTable(
        id: tvSeries.id,
        name: tvSeries.name,
        posterPath: tvSeries.posterPath,
        overview: tvSeries.overview,
      );
  */

  // --- 2. From Database Map to Table ---
  // Used when retrieving data from the local database
  factory TvSeriesTable.fromMap(Map<String, dynamic> map) => TvSeriesTable(
        id: map['id'],
        name: map['name'], // Ensure the key matches the column name
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  // --- 3. To Database Map (JSON) ---
  // Used when inserting or updating the local database
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name, // Key name for the database column
        'posterPath': posterPath,
        'overview': overview,
      };

  // --- 4. To Domain Entity ---
  // Used when the Repository returns Watchlist items to the Use Cases
  TvSeries toEntity() => TvSeries.watchlist(
        id: id,
        overview: overview,
        posterPath: posterPath,
        name: name, // Use 'name' in the watchlist entity constructor
      );

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}
