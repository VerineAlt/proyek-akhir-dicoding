import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTv(mockTvSeriesRepository);
  });

  test('should remove tv series from the repository', () async {
    when(mockTvSeriesRepository.removeWatchlistTv(testTvSeriesDetail))
        .thenAnswer((_) async => Right('Removed from Watchlist'));
        
    final result = await usecase.execute(testTvSeriesDetail);
    
    verify(mockTvSeriesRepository.removeWatchlistTv(testTvSeriesDetail));
    expect(result, Right('Removed from Watchlist'));
  });
}