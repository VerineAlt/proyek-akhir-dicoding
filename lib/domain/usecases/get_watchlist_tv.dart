import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchlistTv {
  final TvSeriesRepository repository;

  GetWatchlistTv(this.repository);

  // Returns a list of the basic TvSeries entity (not TvSeriesDetail).
  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getWatchlistTv();
  }
}