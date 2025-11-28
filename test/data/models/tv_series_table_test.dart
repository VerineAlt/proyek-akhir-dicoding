import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart'; // Uses testTvSeriesDetail and testTvSeries

void main() {
  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'name',
    posterPath: 'posterPath',
    overview: 'overview',
  );
  
  final tTvSeriesMap = {
    'id': 1,
    'name': 'name',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  final tTvSeriesWatchlistEntity = TvSeries.watchlist(
  id: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  name: 'name',
);

  test('should return a valid TvSeriesTable from TvSeriesDetail Entity', () {
    final result = TvSeriesTable.fromEntity(testTvSeriesDetail);
    expect(result, tTvSeriesTable);
  });
  
  test('should convert TvSeriesTable to a JSON Map', () {
    final result = tTvSeriesTable.toJson();
    expect(result, tTvSeriesMap);
  });
  
  test('should convert Map to TvSeriesTable', () {
    final result = TvSeriesTable.fromMap(tTvSeriesMap);
    expect(result, tTvSeriesTable);
  });

  // Note: Assuming testTvSeries is a simplified entity for watchlist view
  test('should convert TvSeriesTable to TvSeries Entity (watchlist entity)', () {
    final result = tTvSeriesTable.toEntity();
    expect(result, tTvSeriesWatchlistEntity); 
  });
}