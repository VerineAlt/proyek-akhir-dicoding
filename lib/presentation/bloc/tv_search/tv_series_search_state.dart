import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TvSeriesSearchEmpty extends TvSeriesSearchState {}

class TvSeriesSearchLoading extends TvSeriesSearchState {}

class TvSeriesSearchError extends TvSeriesSearchState {
  final String message;

  const TvSeriesSearchError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesSearchHasData extends TvSeriesSearchState {
  final List<TvSeries> result;

  const TvSeriesSearchHasData(this.result);

  @override
  List<Object> get props => [result];
}