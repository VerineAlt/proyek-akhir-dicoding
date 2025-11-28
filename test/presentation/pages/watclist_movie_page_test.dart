import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie/watchlist_movie_state.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create Mock Bloc
class MockWatchlistMovieBloc
    extends MockBloc<WatchlistMovieEvent, WatchlistMovieState>
    implements WatchlistMovieBloc {}

class FakeWatchlistMovieEvent extends Fake implements WatchlistMovieEvent {}
class FakeWatchlistMovieState extends Fake implements WatchlistMovieState {}

void main() {
  late MockWatchlistMovieBloc mockWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistMovieEvent());
    registerFallbackValue(FakeWatchlistMovieState());

    // --- ASSET MOCKING ---
    TestWidgetsFlutterBinding.ensureInitialized();
    const String emptyManifest = '{}';
    final ByteData manifestBytes = ByteData.view(
        Uint8List.fromList(emptyManifest.codeUnits).buffer);

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      return manifestBytes;
    });
  });

  setUp(() {
    mockWatchlistBloc = MockWatchlistMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>.value(
      value: mockWatchlistBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tMovie = Movie(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1,
    posterPath: '/path.jpg',
    releaseDate: '2022-01-01',
    title: 'Movie Title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state).thenReturn(WatchlistMovieLoading());

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state)
        .thenReturn(WatchlistMovieHasData(tMovieList));

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
    // Check for poster image to verify item rendering
    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state)
        .thenReturn(const WatchlistMovieError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display empty text when data is empty',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state).thenReturn(WatchlistMovieEmpty());

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
    
    // Ensure this text matches your UI exactly
    expect(find.text('Watchlist is Empty'), findsOneWidget);
  });
}