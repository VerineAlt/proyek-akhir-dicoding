import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();
  
  @override
  List<Object?> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;
  
  const MovieDetailError(this.message);
  
  @override
  List<Object> get props => [message];
}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist; // FIX: Store bool, not Either

  const MovieDetailHasData(this.movie, this.recommendations, this.isAddedToWatchlist);
  
  @override
  List<Object> get props => [movie, recommendations, isAddedToWatchlist];
}

// --- Watchlist States ---

class WatchlistStatusLoaded extends MovieDetailState {
  final bool isAddedToWatchlist;
  
  const WatchlistStatusLoaded(this.isAddedToWatchlist);
  
  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchlistActionSuccess extends MovieDetailState {
  final String message;
  
  const WatchlistActionSuccess(this.message);
  
  @override
  List<Object> get props => [message];
}

class WatchlistActionError extends MovieDetailState {
  final String message;
  
  const WatchlistActionError(this.message);
  
  @override
  List<Object> get props => [message];
}