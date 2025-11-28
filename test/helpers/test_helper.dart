import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tv_series.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendation.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';

import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_series_search_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([
  MockSpec<MovieRepository>(),
  MockSpec<TvSeriesRepository>(),
  MockSpec<MovieRemoteDataSource>(),
  MockSpec<TvSeriesRemoteDataSource>(),
  MockSpec<MovieLocalDataSource>(),
  MockSpec<TvSeriesLocalDataSource>(),
  MockSpec<DatabaseHelper>(),

  // --- MOVIE DETAIL USE CASES ---
  MockSpec<GetMovieDetail>(),
  MockSpec<GetMovieRecommendations>(),
  MockSpec<GetWatchListStatus>(),
  MockSpec<SaveWatchlist>(),
  MockSpec<RemoveWatchlist>(),
  MockSpec<GetNowPlayingMovies>(),
  MockSpec<GetPopularMovies>(),
  MockSpec<GetTopRatedMovies>(),
  MockSpec<SearchMovies>(),
  MockSpec<GetWatchlistMovies>(),

  // --- TV SERIES DETAIL USE CASES ---
  MockSpec<GetTvSeriesDetail>(),
  MockSpec<GetTvSeriesRecommendations>(),
  MockSpec<GetWatchListStatusTv>(),
  MockSpec<SaveWatchlistTv>(),
  MockSpec<RemoveWatchlistTv>(),
  MockSpec<GetAiringTodayTvSeries>(),
  MockSpec<GetPopularTvSeries>(),
  MockSpec<GetTopRatedTvSeries>(),
  MockSpec<SearchTvSeries>(),

  // --- OTHER USE CASES (List/Search) ---
  // MockSpec<SearchMovies>(), // Already implicitly covered by other BLoCs if needed

  // --- BLOCS/BlocS (For testing the Presenter logic itself) ---
  MockSpec<MovieDetailBloc>(),
  MockSpec<TvSeriesDetailBloc>(),
  MockSpec<MovieSearchBloc>(),
  MockSpec<TvSeriesSearchBloc>(),
  MockSpec<NowPlayingMoviesBloc>(),
  MockSpec<PopularMoviesBloc>(),
  MockSpec<TopRatedMoviesBloc>(),
  MockSpec<GetWatchlistTv>(),

  // --- EXTERNAL ---
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}