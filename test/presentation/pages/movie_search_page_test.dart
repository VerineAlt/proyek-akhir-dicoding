import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_event.dart';
import 'package:ditonton/presentation/bloc/movie_search/movie_search_state.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieSearchBloc extends MockBloc<MovieSearchEvent, MovieSearchState>
    implements MovieSearchBloc {}

class FakeMovieSearchEvent extends Fake implements MovieSearchEvent {}
class FakeMovieSearchState extends Fake implements MovieSearchState {}

void main() {
  late MockMovieSearchBloc mockSearchBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieSearchEvent());
    registerFallbackValue(FakeMovieSearchState());

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
    mockSearchBloc = MockMovieSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchBloc>.value(
      value: mockSearchBloc,
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

  testWidgets('Page should display text field', (WidgetTester tester) async {
    when(() => mockSearchBloc.state).thenReturn(MovieSearchEmpty());

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state).thenReturn(MovieSearchLoading());

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state).thenReturn(MovieSearchHasData(tMovieList));

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.byType(ListView), findsOneWidget);
    // Verify content is present
    expect(find.text('Movie Title'), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state)
        .thenReturn(const MovieSearchError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should trigger search event when text is submitted',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state).thenReturn(MovieSearchEmpty());
    
    await tester.pumpWidget(_makeTestableWidget(SearchPage()));

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    verify(() => mockSearchBloc.add(const FetchMovieSearch('spiderman')))
        .called(1);
  });
}