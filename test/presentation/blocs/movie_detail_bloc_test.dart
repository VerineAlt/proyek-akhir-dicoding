import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/genre.dart'; // Needed for MovieDetail
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  // Define testMovieDetail fixture locally to ensure compilation
  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
    budget: 100,
    homepage: "https://google.com",
    imdbId: "tt1",
    originalLanguage: "en",
    popularity: 1,
  );

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailHasData(testMovieDetail, tMovies, true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when get movie detail is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError('Server Failure'),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when get movie recommendations is unsuccessful',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailError('Server Failure'),
      ],
    );
  });

  group('AddWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [WatchlistActionSuccess, WatchlistStatusLoaded] when watchlist is added successfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Added to Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(true));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistActionSuccess('Added to Watchlist'),
        WatchlistStatusLoaded(true),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [WatchlistActionError] when watchlist is not added successfully',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(testMovieDetail)),
      expect: () => [
        WatchlistActionError('Database Failure'),
      ],
    );
  });

  group('RemoveWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [WatchlistActionSuccess, WatchlistStatusLoaded] when watchlist is removed successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Right('Removed from Watchlist'));
        when(mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => Right(false));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistEvent(testMovieDetail)),
      expect: () => [
        WatchlistActionSuccess('Removed from Watchlist'),
        WatchlistStatusLoaded(false),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [WatchlistActionError] when watchlist is not removed successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Database Failure')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlistEvent(testMovieDetail)),
      expect: () => [
        WatchlistActionError('Database Failure'),
      ],
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [WatchlistStatusLoaded] with true when movie is in watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(true));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
      expect: () => [
        WatchlistStatusLoaded(true),
      ],
    );

    // Fixed the syntax error here
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [WatchlistStatusLoaded] with false when movie is not in watchlist',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => Right(false));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatus(tId)),
      expect: () => [
        WatchlistStatusLoaded(false),
      ],
    );
  });
}
