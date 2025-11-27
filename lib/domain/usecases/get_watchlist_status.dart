import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';

class GetWatchListStatus {
  final MovieRepository repository;

  GetWatchListStatus(this.repository);

  Future<Either<Failure,bool>> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
