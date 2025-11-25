import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendation.dart';

import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([
  MockSpec<MovieRepository>(),
  MockSpec<MovieRemoteDataSource>(),
  MockSpec<MovieLocalDataSource>(),
  MockSpec<DatabaseHelper>(),
  
  // TV Series Core Mocks
  MockSpec<TvSeriesRepository>(),
  MockSpec<TvSeriesRemoteDataSource>(),
  MockSpec<TvSeriesLocalDataSource>(),
  
  // TV Series USE CASE Mocks (Add these!)
  MockSpec<GetAiringTodayTvSeries>(),
  MockSpec<GetPopularTvSeries>(),
  MockSpec<GetTopRatedTvSeries>(),
  MockSpec<GetTvSeriesDetail>(),
  MockSpec<GetTvSeriesRecommendations>(),
  MockSpec<SearchTvSeries>(),
  MockSpec<GetWatchListStatusTv>(),
  MockSpec<SaveWatchlistTv>(),
  MockSpec<RemoveWatchlistTv>(),
  MockSpec<GetWatchlistTv>(),

  // External
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}