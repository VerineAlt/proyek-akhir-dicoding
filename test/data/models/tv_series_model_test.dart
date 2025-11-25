import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // test/data/models/tv_series_model_test.dart

// 1. Expected TV Series Entity (Domain Object)
  final tTvSeriesModel = TvSeriesModel(
    adult: false,
    backdropPath: '/path.jpg', // Use a simple value for testing
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2023-01-01',
    name: 'TV Series Name',
    voteAverage: 1.0,
    voteCount: 1,
  );

// 2. Expected TV Series Model (Data Object)
  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1.0,
    posterPath: '/path.jpg',
    firstAirDate: '2023-01-01',
    name: 'TV Series Name',
    voteAverage: 1.0,
    voteCount: 1,
  );

  test('should be a subclass of TvSeries entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
