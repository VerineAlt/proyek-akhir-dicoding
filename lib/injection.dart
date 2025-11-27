import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart'; // NEW
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart'; // NEW
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart'; // NEW
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart'; // NEW

import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendation.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';

import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart'; // NEW
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart'; // NEW
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart'; // NEW
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart'; // NEW

import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart'; // NEW
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart'; // NEW
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart'; // NEW
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart'; // NEW
import 'package:ditonton/domain/usecases/search_tv_series.dart'; // NEW
import 'package:ditonton/presentation/bloc/home_nav/home_nav_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/provider/index_nav_notifier.dart';

import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';

import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart'; // NEW
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart'; // NEW
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart'; // NEW
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart'; // NEW

import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // =========================================================================
  // PRESENTATION LAYER (PROVIDERS)
  // =========================================================================

  // --- Movie Providers (Existing) ---

  // locator.registerFactory(
  //   () => MovieDetailNotifier(
  //     getMovieDetail: locator(),
  //     getMovieRecommendations: locator(),
  //     getWatchListStatus: locator(),
  //     saveWatchlist: locator(),
  //     removeWatchlist: locator(),
  //   ),
  // );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(() => IndexNavNotifier());
  locator.registerFactory(() => MovieSearchBloc(searchMovies: locator()));
  locator.registerFactory(() => HomeNavCubit());
  locator.registerFactory(
      () => WatchlistMovieNotifier(getWatchlistMovies: locator()));

  // --- TV Series Providers (NEW) ---
  locator.registerFactory(
    () => TvSeriesListNotifier(
      getAiringTodayTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeriesDetailNotifier(
      getTvSeriesDetail: locator(),
      getTvSeriesRecommendations: locator(),
      getWatchListStatusTv: locator(),
      saveWatchlistTv: locator(),
      removeWatchlistTv: locator(),
    ),
  );
  locator
      .registerFactory(() => TvSeriesSearchNotifier(searchTvSeries: locator()));
  locator.registerFactory(() => WatchlistTvNotifier(getWatchlistTv: locator()));

  // =========================================================================
  // DOMAIN LAYER (USE CASES)
  // =========================================================================

  // --- Movie Use Cases (Existing) ---
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // --- TV Series Use Cases (NEW) ---
  locator.registerLazySingleton(() => GetAiringTodayTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  // 1. Now Playing
  locator.registerFactory(
    () => NowPlayingMoviesBloc(locator()),
  );

  // 2. Popular
  locator.registerFactory(
    () => PopularMoviesBloc(locator()),
  );

  // 3. Top Rated
  locator.registerFactory(
    () => TopRatedMoviesBloc(locator()),
  );

  // =========================================================================
  // DATA LAYER (REPOSITORIES)
  // =========================================================================

  // --- Movie Repository (Existing) ---
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // --- TV Series Repository (NEW) ---
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // =========================================================================
  // DATA SOURCES
  // =========================================================================

  // --- Movie Data Sources (Existing) ---
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // --- TV Series Data Sources (NEW) ---
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // =========================================================================
  // EXTERNAL
  // =========================================================================

  // --- Helpers (Existing) ---
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // --- External Client (Existing) ---
  locator.registerLazySingleton(() => http.Client());
}
