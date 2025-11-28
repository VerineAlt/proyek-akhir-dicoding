import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group('MovieDetailResponse', () {
    test('should be a subclass of MovieDetail entity', () {
      final result = testMovieDetailResponse.toEntity();
      expect(result, testMovieDetail);
    });

    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap = testMovieDetailMap;
      // act
      final result = MovieDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, testMovieDetailResponse);
    });

    test('should return a JSON map containing proper data', () {
      // arrange
      final expectedJsonMap = testMovieDetailMap;
      // act
      final result = testMovieDetailResponse.toJson();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
