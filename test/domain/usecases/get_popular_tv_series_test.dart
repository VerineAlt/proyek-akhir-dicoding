import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// 1. IMPORT THE GENERATED MOCK FILE
// (Make sure this path points to where your test_helper.mocks.dart is located)
import '../../helpers/test_helper.mocks.dart'; 

// 2. DELETE THE MANUAL CLASS DEFINITION
// class MockTvSeriesRepository extends Mock implements TvSeriesRepository {} <--- DELETE THIS

void main() {
  late GetPopularTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  final tTvSeriesList = <TvSeries>[]; 

  setUp(() {
    // 3. This now uses the Generated Nice Mock
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetPopularTvSeries(mockTvSeriesRepository);
  });
  
  test('should get list of popular TV series from the repository', () async {
    // Arrange
    when(mockTvSeriesRepository.getPopularTvSeries())
        .thenAnswer((_) async => Right(tTvSeriesList));

    // Act
    final result = await usecase.execute();

    // Assert
    expect(result, Right(tTvSeriesList));
    verify(mockTvSeriesRepository.getPopularTvSeries());
  });
}