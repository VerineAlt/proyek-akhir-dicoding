import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_series_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_series_search_event.dart';
import 'package:ditonton/presentation/bloc/tv_search/tv_series_search_state.dart';
import 'package:ditonton/presentation/pages/search_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesSearchBloc
    extends MockBloc<TvSeriesSearchEvent, TvSeriesSearchState>
    implements TvSeriesSearchBloc {}

class FakeTvSeriesSearchEvent extends Fake implements TvSeriesSearchEvent {}
class FakeTvSeriesSearchState extends Fake implements TvSeriesSearchState {}

void main() {
  late MockTvSeriesSearchBloc mockSearchBloc;

  setUpAll(() {
    registerFallbackValue(FakeTvSeriesSearchEvent());
    registerFallbackValue(FakeTvSeriesSearchState());

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
    mockSearchBloc = MockTvSeriesSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesSearchBloc>.value(
      value: mockSearchBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'Original Name',
    overview: 'Overview',
    popularity: 1,
    posterPath: '/path.jpg',
    firstAirDate: '2020-05-05',
    name: 'TV Name',
    voteAverage: 1.0,
    voteCount: 1,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];

  testWidgets('Page should display text field', (WidgetTester tester) async {
    when(() => mockSearchBloc.state).thenReturn(TvSeriesSearchEmpty());

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state).thenReturn(TvSeriesSearchLoading());

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state)
        .thenReturn(TvSeriesSearchHasData(tTvSeriesList));

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    // We verify the item exists by finding the Poster Image container (ClipRRect)
    // reusing the logic that worked for your list page tests
    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state)
        .thenReturn(const TvSeriesSearchError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should trigger search event when text is submitted',
      (WidgetTester tester) async {
    when(() => mockSearchBloc.state).thenReturn(TvSeriesSearchEmpty());
    
    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    // Verify that the BLoC received the event
    verify(() => mockSearchBloc.add(const FetchTvSeriesSearch('spiderman')))
        .called(1);
  });
}