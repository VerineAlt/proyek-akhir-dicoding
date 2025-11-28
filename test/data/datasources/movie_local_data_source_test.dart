import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/models/movie_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  // Dummy Data for Table
  final tMovieTable = MovieTable(
    id: 1,
    title: 'Test Movie',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('insert watchlist', () {
    test('should return success message when insertion to database is successful',
        () async {
      when(mockDatabaseHelper.insertWatchlistMovie(tMovieTable))
          .thenAnswer((_) async => 1);
      final result = await dataSource.insertWatchlist(tMovieTable);
      expect(result, 'Added to Watchlist');
    });

    test(
        'should throw DatabaseException when insertion to database is unsuccessful',
        () async {
      when(mockDatabaseHelper.insertWatchlistMovie(tMovieTable))
          .thenThrow(Exception());
      final call = dataSource.insertWatchlist(tMovieTable);
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is successful',
        () async {
      when(mockDatabaseHelper.removeWatchlistMovie(tMovieTable))
          .thenAnswer((_) async => 1);
      final result = await dataSource.removeWatchlist(tMovieTable);
      expect(result, 'Removed from Watchlist');
    });

    test(
        'should throw DatabaseException when remove from database is unsuccessful',
        () async {
      when(mockDatabaseHelper.removeWatchlistMovie(tMovieTable))
          .thenThrow(Exception());
      final call = dataSource.removeWatchlist(tMovieTable);
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Movie Detail By Id', () {
    final tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      when(mockDatabaseHelper.getMovieById(tId))
          .thenAnswer((_) async => tMovieTable.toJson());
      final result = await dataSource.getMovieById(tId);
      expect(result, tMovieTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getMovieById(tId)).thenAnswer((_) async => null);
      final result = await dataSource.getMovieById(tId);
      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      when(mockDatabaseHelper.getWatchlistMovies())
          .thenAnswer((_) async => [tMovieTable.toJson()]);
      final result = await dataSource.getWatchlistMovies();
      expect(result, [tMovieTable]);
    });
  });
}