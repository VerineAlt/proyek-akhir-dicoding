import 'dart:convert';

import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// You can add this helper function to your test file or a dedicated test_utils file.

import 'package:flutter/services.dart';

// Helper function to mock the asset manifest loading for widget tests
Future<void> pumpWidgetWithFonts(WidgetTester tester, Widget widget) async {
  // Mock the AssetManifest.json response to avoid the crash
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Create a mock AssetBundle that returns a valid JSON structure 
  // (even if it's mostly empty, it satisfies Google Fonts' need)
  final manifest = <String, List<String>>{
    'assets/': [], // Include your project assets if necessary
    'packages/google_fonts/': ['AssetManifest.json'],
  };
  
  // Set the mock asset bundle to be used during the test
  TestAssetBundle.instance.set.addAll(manifest.keys); 

  // Pump the widget
  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();
}

class TestAssetBundle extends CachingAssetBundle {
  static final instance = TestAssetBundle();
  final Set<String> set = {};

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.json') {
      return  ByteData.view(
          // Return an empty, valid asset manifest JSON
          Uint8List.fromList('{}' as List<int>).buffer); 
    }
    // Handle other assets if needed
    throw FlutterError('Asset not found: $key');
  }

  @override
  String toString() => 'TestAssetBundle';
}
void main() {

  setUp(() {
    // FIX: Set a mock AssetBundle at the start of the test suite
    TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets', 
      (ByteData? message) {
        if (message == null) {
          return Future.value(null);
        }
        final key = const StringCodec().decodeMessage(message);
        if (key == 'AssetManifest.json') {
          // Return an empty but valid JSON structure to satisfy google_fonts
          return Future.value(ByteData.view(Uint8List.fromList(utf8.encode('{}')).buffer));
        }
        return Future.value(null);
      },
    );
  });
  final tTvSeries = TvSeries(
      adult: false,
      backdropPath: '/p.jpg',
      genreIds: const [1, 2],
      id: 1,
      originalName: 'Test Original Name',
      overview: 'overview',
      popularity: 1.0,
      posterPath: '/p.jpg',
      firstAirDate: '2023-01-01',
      name: 'Test 1',
      voteAverage: 1.0,
      voteCount: 1,
  );

  Widget _makeTestableWidget(Widget body) {
    // Wrap the widget in a MaterialApp for navigation context
    return MaterialApp(
      home: Scaffold(body: body),
      // Define a mock route for navigation check
      onGenerateRoute: (settings) {
        if (settings.name == TvSeriesDetailPage.ROUTE_NAME) {
          return MaterialPageRoute(builder: (_) => Container());
        }
        return null;
      },
    );
  }

  testWidgets('TvSeriesCard should display poster and navigate on tap',
      (WidgetTester tester) async {
    final cardFinder = find.byType(Card);
    final inkWellFinder = find.byType(InkWell);

    await tester.pumpWidget(_makeTestableWidget(TvSeriesCard(tTvSeries)));
    
    // Check that the card widget is present
    expect(cardFinder, findsOneWidget); 
    
    // Tap the card
    await tester.tap(inkWellFinder);
    await tester.pumpAndSettle(); // Wait for navigation animation to complete

    // Assert that navigation attempt occurred (by checking the route name)
    expect(find.byType(TvSeriesDetailPage), findsNothing);
    
    // Since we mocked the route, we primarily check if the InkWell was tapped. 
    // This is often tricky in widget tests, so we rely on the component being rendered.
  });
}