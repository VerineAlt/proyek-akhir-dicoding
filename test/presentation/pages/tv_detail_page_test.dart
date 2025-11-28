import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_series_detail_state.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create a Mock Bloc using Mocktail/BlocTest
class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

// Fake Event to satisfy Mocktail
class FakeTvSeriesDetailEvent extends Fake implements TvSeriesDetailEvent {}
class FakeTvSeriesDetailState extends Fake implements TvSeriesDetailState {}

void main() {
  late MockTvSeriesDetailBloc mockNotifier;

  setUpAll(() {
    registerFallbackValue(FakeTvSeriesDetailEvent());
    registerFallbackValue(FakeTvSeriesDetailState());

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
    mockNotifier = MockTvSeriesDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tId = 1;

  final tTvSeriesDetail = TvSeriesDetail(
    adult: false,
    backdropPath: 'backdrop',
    firstAirDate: '2022-01-01',
    genres: [],
    id: 1,
    lastAirDate: '2022-01-01',
    lastEpisodeToAir: EpisodeToAir(
        id: 1,
        name: 'name',
        overview: 'ov',
        airDate: 'airDate',
        episodeNumber: 1,
        seasonNumber: 1,
        stillPath: 'stillPath',
        runtime: 1),
    name: 'TV Series Title',
    nextEpisodeToAir: null,
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    overview: 'Test Overview Content', // <--- CHANGED TO UNIQUE TEXT
    posterPath: 'posterPath',
    seasons: [],
    status: 'status',
    tagline: 'tagline',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeriesList = <TvSeries>[];

  testWidgets('Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(TvSeriesDetailLoading());

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: tId)));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display content when data is loaded',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(
        TvSeriesDetailHasData(tTvSeriesDetail, tTvSeriesList, false));

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: tId)));

    expect(find.text('TV Series Title'), findsOneWidget);
    // Check for the UNIQUE content text, not the header
    expect(find.text('Test Overview Content'), findsOneWidget); 
    expect(find.byType(DetailContent), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when TV show not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(
        TvSeriesDetailHasData(tTvSeriesDetail, tTvSeriesList, false));

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: tId)));

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when TV show is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockNotifier.state).thenReturn(
        TvSeriesDetailHasData(tTvSeriesDetail, tTvSeriesList, true));

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: tId)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Page should display Error Message when data load fails',
      (WidgetTester tester) async {
    when(() => mockNotifier.state)
        .thenReturn(const TvSeriesDetailError('Server Failure'));

    await tester.pumpWidget(_makeTestableWidget(TvSeriesDetailPage(id: tId)));

    expect(find.text('Server Failure'), findsOneWidget);
  });
}