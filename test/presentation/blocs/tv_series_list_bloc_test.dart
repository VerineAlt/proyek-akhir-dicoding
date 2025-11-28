import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_list.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late AiringTodayTvSeriesBloc airingTodayTvSeriesBloc;
  late PopularTvSeriesBloc popularTvSeriesBloc;
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;
  late MockGetAiringTodayTvSeries mockGetAiringTodayTvSeries;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  setUp(() {
    mockGetAiringTodayTvSeries = MockGetAiringTodayTvSeries();
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    airingTodayTvSeriesBloc =
        AiringTodayTvSeriesBloc(mockGetAiringTodayTvSeries);
    popularTvSeriesBloc = PopularTvSeriesBloc(mockGetPopularTvSeries);
    topRatedTvSeriesBloc = TopRatedTvSeriesBloc(mockGetTopRatedTvSeries);
  });

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1, adult: false,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('AiringTodayTvSeriesBloc', () {
    test('initial state should be empty', () {
      expect(airingTodayTvSeriesBloc.state, TvSeriesEmpty());
    });

    blocTest<AiringTodayTvSeriesBloc, TvSeriesState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetAiringTodayTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return airingTodayTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
      expect: () => [
        TvSeriesLoading(),
        TvSeriesHasData(tTvSeriesList),
      ],
    );

    blocTest<AiringTodayTvSeriesBloc, TvSeriesState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetAiringTodayTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return airingTodayTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchAiringTodayTvSeries()),
      expect: () => [
        TvSeriesLoading(),
        TvSeriesError('Server Failure'),
      ],
    );
  });

  group('PopularTvSeriesBloc', () {
    test('initial state should be empty', () {
      expect(popularTvSeriesBloc.state, TvSeriesEmpty());
    });

    blocTest<PopularTvSeriesBloc, TvSeriesState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        TvSeriesLoading(),
        TvSeriesHasData(tTvSeriesList),
      ],
    );

    blocTest<PopularTvSeriesBloc, TvSeriesState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        TvSeriesLoading(),
        TvSeriesError('Server Failure'),
      ],
    );
  });

  group('TopRatedTvSeriesBloc', () {
    test('initial state should be empty', () {
      expect(topRatedTvSeriesBloc.state, TvSeriesEmpty());
    });

    blocTest<TopRatedTvSeriesBloc, TvSeriesState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TvSeriesLoading(),
        TvSeriesHasData(tTvSeriesList),
      ],
    );

    blocTest<TopRatedTvSeriesBloc, TvSeriesState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TvSeriesLoading(),
        TvSeriesError('Server Failure'),
      ],
    );
  });
}
