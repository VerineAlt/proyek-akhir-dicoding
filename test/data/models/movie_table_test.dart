import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart'; // Uses testMovieDetail and testMovie

void main() {
  // Test fixture data
  final tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );
  
  final tMovieMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  final tMovieWatchlistEntity = Movie.watchlist(
  id: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  title: 'title',
);

  test('should return a valid MovieTable from MovieDetail Entity', () {
    // Assume testMovieDetail is defined in dummy_objects.dart
    final result = MovieTable.fromEntity(testMovieDetail);
    
    // Note: The MovieTable.fromEntity constructor must be modified to accept MovieDetail
    // if that's what your code uses (or assume it takes Movie as the project standard dictates)
    expect(result, tMovieTable); 
  });
  
  test('should convert MovieTable to a JSON Map', () {
    final result = tMovieTable.toJson();
    expect(result, tMovieMap);
  });
  
  test('should convert Map to MovieTable', () {
    final result = MovieTable.fromMap(tMovieMap);
    expect(result, tMovieTable);
  });

  test('should convert MovieTable to Movie Entity (watchlist entity)', () {
    final result = tMovieTable.toEntity();
    // Assuming testMovie is the entity fixture for simple Movie entity
    expect(result, tMovieWatchlistEntity); 
  });
}