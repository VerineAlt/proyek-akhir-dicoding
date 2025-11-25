import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieModel = TvSeriesModel(
    adult: false,
    backdropPath: "/path.jpg",
    genreIds: [1, 2, 3, 4],
    id: 1,
    originalName: "Original Title",
    overview: "Overview",
    popularity: 1.0,
    posterPath: "/path.jpg",
    name: "Title",
    voteAverage: 1.0,
    voteCount: 1,
    firstAirDate: '2020-05-05',
  );
  final tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tMovieModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv/airing_today.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange (No arrange needed here)
      
      // act
      final result = tTvSeriesResponseModel.toJson();
      
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/path.jpg", // CORRECTED
            "genre_ids": [1, 2, 3, 4], // CORRECTED
            "id": 1,
            "original_name": "Original Title", // CORRECTED
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg", // CORRECTED
            "first_air_date": "2020-05-05", // CORRECTED (removed extra ")
            "name": "Title", // CORRECTED
            "vote_average": 1.0,
            "vote_count": 1,
          }
        ],
      };
      // Note: Use mapEquals if relying on raw Maps from dart:collection
      expect(result, expectedJsonMap);
    });
  });
}
