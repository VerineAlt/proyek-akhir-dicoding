import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../../helpers/test_helper.mocks.dart'; 

void main() {
  late GetWatchlistTv usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchlistTv(mockTvSeriesRepository);
  });
  
  // Define a minimal list of TV Series entities for the successful return
  final tTvSeriesList = <TvSeries>[
    TvSeries.watchlist(id: 1, overview: 'ov', posterPath: 'path', name: 'name')
  ];

  test('should get list of TV series from watchlist repository', () async {
    // arrange
    when(mockTvSeriesRepository.getWatchlistTv())
        .thenAnswer((_) async => Right(tTvSeriesList));

    // act
    final result = await usecase.execute();

    // assert
    expect(result, Right(tTvSeriesList));
    verify(mockTvSeriesRepository.getWatchlistTv());
  });
}