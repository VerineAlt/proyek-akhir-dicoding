import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart'; // Recommended for search debounce

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchEmpty()) {
    on<FetchMovieSearch>((event, emit) async {
      emit(MovieSearchLoading());
      
      final result = await searchMovies.execute(event.query);
      result.fold(
        (failure) {
          emit(MovieSearchError(failure.message));
        },
        (data) {
          emit(MovieSearchHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}