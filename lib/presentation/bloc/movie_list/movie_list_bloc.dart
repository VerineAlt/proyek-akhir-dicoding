import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_event.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_state.dart';

// BLOC 1: Now Playing
class NowPlayingMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMoviesBloc(this._getNowPlayingMovies) : super(MovieListEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await _getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (data) => emit(MovieListHasData(data)),
      );
    });
  }
}

// BLOC 2: Popular
class PopularMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetPopularMovies _getPopularMovies;

  PopularMoviesBloc(this._getPopularMovies) : super(MovieListEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await _getPopularMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (data) => emit(MovieListHasData(data)),
      );
    });
  }
}

// BLOC 3: Top Rated
class TopRatedMoviesBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(MovieListEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(MovieListLoading());
      final result = await _getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(MovieListError(failure.message)),
        (data) => emit(MovieListHasData(data)),
      );
    });
  }
}