import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();
  
  @override
  List<Object> get props => [];
}

class TvSeriesDetailEmpty extends TvSeriesDetailState {}

class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  const TvSeriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesDetailHasData extends TvSeriesDetailState {
  final TvSeriesDetail tvSeriesDetail;
  final List<TvSeries> tvSeriesRecommendations;
  // We include the status here to ensure data consistency
  final bool isAddedToWatchlist; 

  const TvSeriesDetailHasData(this.tvSeriesDetail, this.tvSeriesRecommendations, this.isAddedToWatchlist);

  @override
  List<Object> get props => [tvSeriesDetail, tvSeriesRecommendations, isAddedToWatchlist];
}

// --- Watchlist Specific States (For Side Effects) ---

class WatchlistStatusLoaded extends TvSeriesDetailState {
  final bool isAddedToWatchlist;

  const WatchlistStatusLoaded(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchlistActionSuccess extends TvSeriesDetailState {
  final String message;

  const WatchlistActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistActionError extends TvSeriesDetailState {
  final String message;

  const WatchlistActionError(this.message);

  @override
  List<Object> get props => [message];
}