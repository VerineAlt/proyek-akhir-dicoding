import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Import the generated mocks file
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  // Dummy Data
  final tTvSeriesTable = TvSeriesTable(
    id: 1,
    name: 'Test TV',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  group('save watchlist', () {
    test('should return success message when insertion to database is successful',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTv(tTvSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.insertWatchlist(tTvSeriesTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insertion to database is unsuccessful',
        () async {
      // arrange
      when(mockDatabaseHelper.insertWatchlistTv(tTvSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.insertWatchlist(tTvSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is successful',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTv(tTvSeriesTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSource.removeWatchlist(tTvSeriesTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is unsuccessful',
        () async {
      // arrange
      when(mockDatabaseHelper.removeWatchlistTv(tTvSeriesTable))
          .thenThrow(Exception());
      // act
      final call = dataSource.removeWatchlist(tTvSeriesTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Series Detail By Id', () {
    final tId = 1;

    test('should return TV Series Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId))
          .thenAnswer((_) async => tTvSeriesTable.toJson());
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, tTvSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTvSeriesById(tId))
          .thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTvSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TvSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTv())
          .thenAnswer((_) async => [tTvSeriesTable.toJson()]);
      // act
      final result = await dataSource.getWatchlistTv();
      // assert
      expect(result, [tTvSeriesTable]);
    });
  });
}