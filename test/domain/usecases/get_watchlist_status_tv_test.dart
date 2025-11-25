import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart'; 

void main() {
  late GetWatchListStatusTv usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchListStatusTv(mockTvSeriesRepository);
  });
  
  const tId = 1;

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockTvSeriesRepository.isAddedToWatchlistTv(tId))
        .thenAnswer((_) async => const Right(true));

    // act
    final result = await usecase.execute(tId);

    // assert
    expect(result, const Right(true));
    verify(mockTvSeriesRepository.isAddedToWatchlistTv(tId));
  });
}