import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class GetWatchListStatusTv {
  final TvSeriesRepository repository;

  GetWatchListStatusTv(this.repository);

  // Returns true if the ID exists in the watchlist.
  Future<Either<Failure, bool>> execute(int id) {
    return repository.isAddedToWatchlistTv(id);
  }
}