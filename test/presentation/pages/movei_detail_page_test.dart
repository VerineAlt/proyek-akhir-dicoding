import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}
class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockNotifier;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());

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
    mockNotifier = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tId = 1;

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdrop',
    genres: [],
    id: 1,
    originalTitle: 'Original Title',
    // FIX: Use unique text so it doesn't clash with the static 'Overview' header
    overview: 'Test Overview Content', 
    posterPath: 'posterPath',
    releaseDate: '2022-01-01',
    runtime: 120,
    title: 'Title',
    voteAverage: 1,
    voteCount: 1,
    budget: 100,
    homepage: "https://google.com",
    imdbId: "tt1",
    originalLanguage: "en", popularity: 1.0,
  );

  final tMovieList = <Movie>[];

  testWidgets('Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(MovieDetailLoading());

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display content when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(
        MovieDetailHasData(tMovieDetail, tMovieList, false));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

    expect(find.text('Title'), findsOneWidget);
    // FIX: Check for the unique content text
    expect(find.text('Test Overview Content'), findsOneWidget);
    expect(find.byType(DetailContent), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(
        MovieDetailHasData(tMovieDetail, tMovieList, false));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

    expect(find.byIcon(Icons.add), findsOneWidget);
    // Use FilledButton or whatever button type you used in the UI
    expect(find.byType(FilledButton), findsOneWidget); 
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(
        MovieDetailHasData(tMovieDetail, tMovieList, true));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Page should display Error Message when data load fails',
      (WidgetTester tester) async {
    when(() => mockNotifier.state)
        .thenReturn(const MovieDetailError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: tId)));

    expect(find.text('Server Failure'), findsOneWidget);
  });
}