import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
// Import Use Cases
// Alias Use Case
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_state.dart';
// Import BLoC components
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart'; // Assuming testTvSeriesDetail is here
import '../../helpers/test_helper.mocks.dart';
import '../../helpers/test_helper.mocks.dart' as usecase;

void main() {
  late TvSeriesDetailBloc tvSeriesDetailBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late usecase.MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = usecase.MockRemoveWatchlistTv();
    tvSeriesDetailBloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      getWatchListStatusTv: mockGetWatchListStatusTv,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

  final tId = 1;
  // Define list for testing
  final tTvSeriesList = <TvSeries>[];

  // --- GROUP: FETCH DETAIL ---
  group('FetchTvSeriesDetail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesList));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => Right(true));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailLoading(),
        TvSeriesDetailHasData(testTvSeriesDetail, tTvSeriesList, true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [Loading, Error] when get tv series detail is unsuccessful',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeriesList));
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => Right(true));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(FetchTvSeriesDetail(tId)),
      expect: () => [
        TvSeriesDetailLoading(),
        TvSeriesDetailError('Server Failure'),
      ],
    );
  });

  // --- GROUP: ADD WATCHLIST ---
  group('AddWatchlistTv', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [WatchlistActionSuccess, WatchlistStatusLoaded] when watchlist is added successfully',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatusTv.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => Right(true));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvSeriesDetail)),
      expect: () => [
        WatchlistActionSuccess('Added to Watchlist'),
        WatchlistStatusLoaded(true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [WatchlistActionError] when watchlist is not added successfully',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTv(testTvSeriesDetail)),
      expect: () => [
        WatchlistActionError('Database Failure'),
      ],
    );
  });

  // --- GROUP: REMOVE WATCHLIST ---
  group('RemoveWatchlistTv', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [WatchlistActionSuccess, WatchlistStatusLoaded] when watchlist is removed successfully',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchListStatusTv.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => Right(false));
        return tvSeriesDetailBloc;
      },
      // FIX: Use RemoveWatchlistTvEvent if you renamed it, or verify import
      act: (bloc) => bloc.add(RemoveWatchlistTv(testTvSeriesDetail)), 
      expect: () => [
        WatchlistActionSuccess('Removed from Watchlist'),
        WatchlistStatusLoaded(false),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [WatchlistActionError] when watchlist is not removed successfully',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistTv(testTvSeriesDetail)),
      expect: () => [
        WatchlistActionError('Database Failure'),
      ],
    );
  });

  // --- GROUP: LOAD STATUS ---
  group('LoadWatchlistStatusTv', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [WatchlistStatusLoaded] with true when tv series is in watchlist',
      build: () {
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => Right(true));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusTv(tId)),
      expect: () => [
        WatchlistStatusLoaded(true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit [WatchlistStatusLoaded] with false when tv series is not in watchlist',
      build: () {
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => Right(false));
        return tvSeriesDetailBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusTv(tId)),
      expect: () => [
        WatchlistStatusLoaded(false),
      ],
    );
  });
}