import 'dart:typed_data';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovie = Movie(
    adult: false,
    backdropPath: '/p.jpg',
    genreIds: const [1, 2],
    id: 1,
    originalTitle: 'Test Original Title',
    overview: 'Test Overview',
    popularity: 1.0,
    posterPath: '/p.jpg',
    releaseDate: '2023-01-01',
    title: 'Test Movie',
    video: false,
    voteAverage: 1.0,
    voteCount: 1,
  );

  // --- FIX START: Mock the Asset Loading System ---
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();

    // 1. Create the mock data (Empty JSON)
    const String emptyManifest = '{}';
    final ByteData manifestBytes = ByteData.view(
        Uint8List.fromList(emptyManifest.codeUnits).buffer);

    // 2. Intercept the platform channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      // 3. Return the mock data (manifestBytes) instead of the request (message)
      // This tricks google_fonts into thinking the asset manifest is loaded but empty.
      return manifestBytes; 
    });
  });
  // --- FIX END ---

  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      onGenerateRoute: (settings) {
        if (settings.name == MovieDetailPage.ROUTE_NAME) {
          return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Detail Page')));
        }
        return null;
      },
    );
  }

  testWidgets('MovieCard should display content and navigate on tap',
      (WidgetTester tester) async {
    final cardFinder = find.byType(Card);
    final inkWellFinder = find.byType(InkWell);
    final textFinder = find.text('Test Movie');

    await tester.pumpWidget(_makeTestableWidget(MovieCard(tMovie)));

    expect(cardFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);

    await tester.tap(inkWellFinder);
    await tester.pumpAndSettle();

    expect(find.text('Detail Page'), findsOneWidget);
  });
}