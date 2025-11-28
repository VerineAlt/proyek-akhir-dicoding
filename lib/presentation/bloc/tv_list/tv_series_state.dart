import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class TvSeriesState extends Equatable {
  const TvSeriesState();

  @override
  List<Object> get props => [];
}

class TvSeriesEmpty extends TvSeriesState {}

class TvSeriesLoading extends TvSeriesState {}

class TvSeriesError extends TvSeriesState {
  final String message;

  const TvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesHasData extends TvSeriesState {
  final List<TvSeries> result;

  const TvSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}