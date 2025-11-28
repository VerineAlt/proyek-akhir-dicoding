import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create Mock Bloc
class MockWatchlistTvBloc
    extends MockBloc<WatchlistTvEvent, WatchlistTvState>
    implements WatchlistTvBloc {}

// Fake Event/State
class FakeWatchlistTvEvent extends Fake implements WatchlistTvEvent {}
class FakeWatchlistTvState extends Fake implements WatchlistTvState {}

void main() {
  late MockWatchlistTvBloc mockWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistTvEvent());
    registerFallbackValue(FakeWatchlistTvState());

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
    mockWatchlistBloc = MockWatchlistTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>.value(
      value: mockWatchlistBloc,
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

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state).thenReturn(WatchlistTvLoading());

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state)
        .thenReturn(WatchlistTvHasData(tTvSeriesList));

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(find.byType(ListView), findsOneWidget);
    // Verify item is rendered by finding its poster clip
    expect(find.byType(ClipRRect), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockWatchlistBloc.state)
        .thenReturn(const WatchlistTvError('Error message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Page should display empty text when data is empty',
      (WidgetTester tester) async {
    // Assuming your page shows specific text for empty state
    // Check your WatchlistTvPage.dart to match the text exactly
    when(() => mockWatchlistBloc.state).thenReturn(WatchlistTvEmpty()); // Or HasData([]) if logic differs

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    // Update this string if your UI uses a different empty message
    expect(find.text('Watchlist is Empty'), findsOneWidget); 
  });
}