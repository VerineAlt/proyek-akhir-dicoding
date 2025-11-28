import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSeriesDetail extends TvSeriesDetailEvent {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlistTv extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddWatchlistTv(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveWatchlistTv extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveWatchlistTv(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class LoadWatchlistStatusTv extends TvSeriesDetailEvent {
  final int id;

  const LoadWatchlistStatusTv(this.id);

  @override
  List<Object> get props => [id];
}