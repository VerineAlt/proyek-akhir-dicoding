import 'package:equatable/equatable.dart';

abstract class TvSeriesSearchEvent extends Equatable {
  const TvSeriesSearchEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSeriesSearch extends TvSeriesSearchEvent {
  final String query;

  const FetchTvSeriesSearch(this.query);

  @override
  List<Object> get props => [query];
}