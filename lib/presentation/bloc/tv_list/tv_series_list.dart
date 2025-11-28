import 'package:equatable/equatable.dart';

abstract class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();

  @override
  List<Object> get props => [];
}

class FetchAiringTodayTvSeries extends TvSeriesListEvent {}
class FetchPopularTvSeries extends TvSeriesListEvent {}
class FetchTopRatedTvSeries extends TvSeriesListEvent {}