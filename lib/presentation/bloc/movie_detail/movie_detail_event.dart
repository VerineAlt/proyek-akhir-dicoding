import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchMovieDetail extends MovieDetailEvent {
  final int id;
  const FetchMovieDetail(this.id);
  @override
  List<Object> get props => [id];
}

class AddWatchlist extends MovieDetailEvent {
  final MovieDetail movie;
  const AddWatchlist(this.movie);
  @override
  List<Object> get props => [movie];
}

class RemoveWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;
  const RemoveWatchlistEvent(this.movie);
  @override
  List<Object> get props => [movie];
}

class LoadWatchlistStatus extends MovieDetailEvent {
  final int id;
  const LoadWatchlistStatus(this.id);
  @override
  List<Object> get props => [id];
}