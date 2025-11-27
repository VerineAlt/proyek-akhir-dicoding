import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMovieBloc extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies})
      : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovie>((event, emit) async {
      emit(WatchlistMovieLoading());

      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) {
          emit(WatchlistMovieError(failure.message));
        },
        (data) {
          if (data.isEmpty) {
            emit(WatchlistMovieEmpty());
          } else {
            emit(WatchlistMovieHasData(data));
          }
        },
      );
    });
  }
}