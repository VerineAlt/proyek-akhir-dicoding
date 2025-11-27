import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieSearch extends MovieSearchEvent {
  final String query;

  const FetchMovieSearch(this.query);

  @override
  List<Object> get props => [query];
}