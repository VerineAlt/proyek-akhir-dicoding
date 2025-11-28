import 'dart:convert';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  final tId = 1;
  
  // Assumed fixture location: test/dummy_data/tv/airing_today.json
  final tTvSeriesList = TvSeriesResponse.fromJson(
          json.decode(readJson('dummy_data/tv/airing_today.json')))
      .tvSeriesList;

  // --- 1. GET AIRING TODAY TV SERIES ---
  group('get Airing Today TV Series', () {
    const tUrl = '$BASE_URL/tv/airing_today?$API_KEY';

    test('should return list of TvSeries Model when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/airing_today.json'), 200));
      final result = await dataSource.getAiringTodayTvSeries();
      expect(result, equals(tTvSeriesList));
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getAiringTodayTvSeries();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  // --- 2. GET TV SERIES DETAIL ---
  group('get TV Series Detail', () {
    final tTvSeriesDetail = TvSeriesDetailModel.fromJson(
        json.decode(readJson('dummy_data/tv/tv_detail.json')));
    final tUrl = '$BASE_URL/tv/$tId?$API_KEY';

    test('should return Tv Series Detail when the response code is 200', () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv/tv_detail.json'), 200));
      final result = await dataSource.getTvSeriesDetail(tId);
      expect(result, equals(tTvSeriesDetail));
    });
    
    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getTvSeriesDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
  
  // NOTE: You must repeat this pattern for Popular, Top Rated, Recommendations, and Search.
}