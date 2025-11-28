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

  test('should get watchlist status from repository', () async {
    when(mockTvSeriesRepository.isAddedToWatchlistTv(1))
        .thenAnswer((_) async => Right(true));
        
    final result = await usecase.execute(1);
    
    expect(result, Right(true));
  });
}