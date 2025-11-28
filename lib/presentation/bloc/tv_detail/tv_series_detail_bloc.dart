import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendation.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
// Alias the remove use case to avoid conflict with the Event class
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart' as usecase;
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_state.dart'; 

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final usecase.RemoveWatchlistTv removeWatchlistTv; // Use the alias

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(TvSeriesDetailEmpty()) {
    
    // 1. Fetch Detail, Recommendations, and Status
    on<FetchTvSeriesDetail>((event, emit) async {
      emit(TvSeriesDetailLoading());
      
      final detailResult = await getTvSeriesDetail.execute(event.id);
      final recommendationResult = await getTvSeriesRecommendations.execute(event.id);
      final statusResult = await getWatchListStatusTv.execute(event.id);

      // Unwrap status (Default to false if failure)
      bool isAdded = false;
      statusResult.fold((_) => isAdded = false, (status) => isAdded = status);

      detailResult.fold(
        (failure) {
          emit(TvSeriesDetailError(failure.message));
        },
        (tvSeriesDetail) {
          recommendationResult.fold(
            (failure) {
              // If recs fail, we still show detail
              emit(TvSeriesDetailHasData(tvSeriesDetail, [], isAdded));
            },
            (tvSeriesRecommendations) {
              emit(TvSeriesDetailHasData(tvSeriesDetail, tvSeriesRecommendations, isAdded));
            },
          );
        },
      );
    });

    // 2. Add to Watchlist
    on<AddWatchlistTv>((event, emit) async {
      final result = await saveWatchlistTv.execute(event.tvSeries);

      result.fold(
        (failure) {
          emit(WatchlistActionError(failure.message));
        },
        (successMessage) {
          emit(WatchlistActionSuccess(successMessage));
          // Reload status to update UI
          add(LoadWatchlistStatusTv(event.tvSeries.id)); 
        },
      );
    });

    // 3. Remove from Watchlist
    on<RemoveWatchlistTv>((event, emit) async {
      final result = await removeWatchlistTv.execute(event.tvSeries);

      result.fold(
        (failure) {
          emit(WatchlistActionError(failure.message));
        },
        (successMessage) {
          emit(WatchlistActionSuccess(successMessage));
          // Reload status to update UI
          add(LoadWatchlistStatusTv(event.tvSeries.id));
        },
      );
    });

    // 4. Load Status
    on<LoadWatchlistStatusTv>((event, emit) async {
      final result = await getWatchListStatusTv.execute(event.id);
      
      result.fold(
        (_) {}, // Do nothing on failure
        (status) {
          emit(WatchlistStatusLoaded(status));
        },
      );
    });
  }
}