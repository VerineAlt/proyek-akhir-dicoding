import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_list/tv_series_state.dart';
import 'package:ditonton/presentation/pages/home_tv_series_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

// 1. Create Mock Cubits using Mocktail
class MockAiringTodayTvSeriesCubit extends MockCubit<TvSeriesState>
    implements AiringTodayTvSeriesBloc {}

class MockPopularTvSeriesCubit extends MockCubit<TvSeriesState>
    implements PopularTvSeriesBloc {}

class MockTopRatedTvSeriesCubit extends MockCubit<TvSeriesState>
    implements TopRatedTvSeriesBloc {}

void main() {
  late MockAiringTodayTvSeriesCubit mockAiringTodayCubit;
  late MockPopularTvSeriesCubit mockPopularCubit;
  late MockTopRatedTvSeriesCubit mockTopRatedCubit;

  setUpAll(() {
    // --- GOOGLE FONTS MOCKING (Required) ---
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
    mockAiringTodayCubit = MockAiringTodayTvSeriesCubit();
    mockPopularCubit = MockPopularTvSeriesCubit();
    mockTopRatedCubit = MockTopRatedTvSeriesCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AiringTodayTvSeriesBloc>.value(value: mockAiringTodayCubit),
        BlocProvider<PopularTvSeriesBloc>.value(value: mockPopularCubit),
        BlocProvider<TopRatedTvSeriesBloc>.value(value: mockTopRatedCubit),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  
  final tTvSeriesList = <TvSeries>[testTvSeries];

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    // Arrange: All cubits loading
    when(() => mockAiringTodayCubit.state).thenReturn(TvSeriesLoading());
    when(() => mockPopularCubit.state).thenReturn(TvSeriesLoading());
    when(() => mockTopRatedCubit.state).thenReturn(TvSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(TvSeriesPage()));

    // Assert: We expect 3 progress indicators (one for each section)
    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    // Arrange: All cubits have data
    when(() => mockAiringTodayCubit.state).thenReturn(TvSeriesHasData(tTvSeriesList));
    when(() => mockPopularCubit.state).thenReturn(TvSeriesHasData(tTvSeriesList));
    when(() => mockTopRatedCubit.state).thenReturn(TvSeriesHasData(tTvSeriesList));

    await tester.pumpWidget(_makeTestableWidget(TvSeriesPage()));

    // Assert: Check for the specific list view structure (3 lists)
    expect(find.byType(ListView), findsNWidgets(3));
    
    // FIX: Check for InkWell (the clickable item) instead of Text
    // Since we provided a list with 1 item to all 3 Cubits, we expect 3 items total.
    expect(find.byType(ClipRRect), findsNWidgets(3));
  });

  testWidgets('Page should display Error text when data fetch fails',
      (WidgetTester tester) async {
    // Arrange: All cubits error
    when(() => mockAiringTodayCubit.state).thenReturn(const TvSeriesError('Error Airing'));
    when(() => mockPopularCubit.state).thenReturn(const TvSeriesError('Error Popular'));
    when(() => mockTopRatedCubit.state).thenReturn(const TvSeriesError('Error Top Rated'));

    await tester.pumpWidget(_makeTestableWidget(TvSeriesPage()));

    expect(find.text('Error Airing'), findsOneWidget);
    expect(find.text('Error Popular'), findsOneWidget);
    expect(find.text('Error Top Rated'), findsOneWidget);
  });
}