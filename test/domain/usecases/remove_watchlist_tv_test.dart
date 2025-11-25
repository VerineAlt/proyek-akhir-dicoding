import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTv(mockTvSeriesRepository);
  });

  // Reuse the detailed fixture
  final tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    firstAirDate: '2022-01-01',
    genres: [],
    id: 1,
    lastAirDate: '2022-01-01',
    lastEpisodeToAir: EpisodeToAir(id: 1, name: 'name', overview: 'overview', airDate: 'airDate', episodeNumber: 1, seasonNumber: 1, stillPath: 'stillPath', runtime: 1),
    name: 'name',
    nextEpisodeToAir: null,
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    seasons: [],
    status: 'status',
    tagline: 'tagline',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should remove tv series from the repository', () async {
    // arrange
    when(mockTvSeriesRepository.removeWatchlistTv(tTvSeriesDetail))
        .thenAnswer((_) async => Right('Removed from Watchlist'));
    // act
    final result = await usecase.execute(tTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.removeWatchlistTv(tTvSeriesDetail));
    expect(result, Right('Removed from Watchlist'));
  });
}