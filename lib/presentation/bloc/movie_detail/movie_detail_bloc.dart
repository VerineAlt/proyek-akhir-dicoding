import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailEmpty()) {
    
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());
      
      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult = await getMovieRecommendations.execute(event.id);
      final statusResult = await getWatchListStatus.execute(event.id);
      
      // FIX: Extract boolean from Either
      // Default to false if the status check fails
      bool isAddedToWatchlist = false;
      statusResult.fold(
        (_) => isAddedToWatchlist = false,
        (status) => isAddedToWatchlist = status,
      );

      detailResult.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (movie) {
          recommendationResult.fold(
            (failure) => emit(MovieDetailError(failure.message)),
            (movies) {
              // FIX: Pass the boolean variable, not the statusResult object
              emit(MovieDetailHasData(movie, movies, isAddedToWatchlist));
            },
          );
        },
      );
    });

    on<AddWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(WatchlistActionError(failure.message)),
        (successMessage) {
          emit(WatchlistActionSuccess(successMessage));
          add(LoadWatchlistStatus(event.movie.id));
        },
      );
    });

    on<RemoveWatchlistEvent>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);
      result.fold(
        (failure) => emit(WatchlistActionError(failure.message)),
        (successMessage) {
          emit(WatchlistActionSuccess(successMessage));
          add(LoadWatchlistStatus(event.movie.id));
        },
      );
    });

    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      result.fold(
         (failure) => emit(WatchlistStatusLoaded(false)),
         (isAdded) => emit(WatchlistStatusLoaded(isAdded)),
      );
    });
  }
}