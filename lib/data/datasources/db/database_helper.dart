import 'dart:async';

import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  static void setDb(Database db) {
    _database = db;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlistMovie = 'watchlist_movie';
  static const String _tblWatchlistTv = 'watchlist_tv';

  // --- MIGRATION: Handles upgrades from any previous version ---
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // FIX: Execute creation of BOTH tables if upgrading from a version less than 3
    if (oldVersion < 3) {
      // 1. Ensure the Movie Watchlist Table exists (Fixes the current error)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_tblWatchlistMovie (
          id INTEGER PRIMARY KEY,
          title TEXT,
          overview TEXT,
          posterPath TEXT
        );
      ''');

      // 2. Ensure the TV Series Watchlist Table exists
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_tblWatchlistTv (
          id INTEGER PRIMARY KEY,
          name TEXT,
          overview TEXT,
          posterPath TEXT
        );
      ''');
    }
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    // FIX: Bump version to 3 to force the _onUpgrade migration to run now
    var db = await openDatabase(databasePath,
        version: 3, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  // --- CREATION: Runs only for brand new installs (V3) ---
  void _onCreate(Database db, int version) async {
    // 1. Create Movie Watchlist Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblWatchlistMovie (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');

    // 2. Create TV Series Watchlist Table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  // =========================================================
  // --- MOVIE METHODS ---
  // =========================================================

  Future<int> insertWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db!.insert(_tblWatchlistMovie, movie.toJson());
  }

  Future<int> removeWatchlistMovie(MovieTable movie) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistMovie,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> results =
        await db!.query(_tblWatchlistMovie);

    return results;
  }

  // =========================================================
  // --- TV SERIES METHODS ---
  // =========================================================

  Future<int> insertWatchlistTv(TvSeriesTable tvSeries) async {
    final db = await database;
    return await db!.insert(_tblWatchlistTv, tvSeries.toJson());
  }

  Future<int> removeWatchlistTv(TvSeriesTable tvSeries) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [tvSeries.id],
    );
  }

  Future<Map<String, dynamic>?> getTvSeriesById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTv() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlistTv);

    return results;
  }
}
