import 'dart:convert';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart'; // MockHttpClient

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  // --- GET NOW PLAYING MOVIES ---
  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie/now_playing.json')))
        .movieList;
    const tUrl = '$BASE_URL/movie/now_playing?$API_KEY';

    test('should return list of Movie Model when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie/now_playing.json'), 200));
      final result = await dataSource.getNowPlayingMovies();
      expect(result, equals(tMovieList));
    });

    test('should throw a ServerException when response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getNowPlayingMovies();
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  // --- GET MOVIE DETAIL ---
  group('get Movie Detail', () {
    final tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
        json.decode(readJson('dummy_data/movie/movie_detail.json')));
    final tUrl = '$BASE_URL/movie/$tId?$API_KEY';

    test('should return Movie Detail when the response code is 200', () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie/movie_detail.json'), 200));
      final result = await dataSource.getMovieDetail(tId);
      expect(result, equals(tMovieDetail));
    });
    
    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getMovieDetail(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  // --- GET MOVIE RECOMMENDATIONS ---
  group('get Movie Recommendations', () {
    final tId = 1;
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie/movie_recommendations.json')))
        .movieList;
    final tUrl = '$BASE_URL/movie/$tId/recommendations?$API_KEY';

    test('should return list of Movie Model when the response code is 200',
        () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie/movie_recommendations.json'), 200));
      final result = await dataSource.getMovieRecommendations(tId);
      expect(result, equals(tMovieList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.getMovieRecommendations(tId);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  // --- SEARCH MOVIES ---
  group('search Movies', () {
    final tQuery = 'Spiderman';
    final tMovieList = MovieResponse.fromJson(
            json.decode(readJson('dummy_data/movie/search_spiderman_movie.json')))
        .movieList;
    final tUrl = '$BASE_URL/search/movie?$API_KEY&query=$tQuery';

    test('should return list of movies when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/movie/search_spiderman_movie.json'), 200));
      final result = await dataSource.searchMovies(tQuery);
      expect(result, tMovieList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      when(mockHttpClient.get(Uri.parse(tUrl)))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      final call = dataSource.searchMovies(tQuery);
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}