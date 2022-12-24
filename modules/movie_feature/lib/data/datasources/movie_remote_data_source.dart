import 'dart:convert';

import 'package:movie_feature/data/models/movie_detail_model.dart';
import 'package:movie_feature/data/models/movie_model.dart';
import 'package:movie_feature/data/models/movie_response.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  MovieRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get(Uri.parse('$baseUrl/movie/now_playing'));
    return MovieResponse.fromJson(json.decode(response.body)).movieList;
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/movie/$id'));
    return MovieDetailResponse.fromJson(json.decode(response.body));
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/movie/$id/recommendations'),
    );
    return MovieResponse.fromJson(json.decode(response.body)).movieList;
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await client.get(Uri.parse('$baseUrl/movie/popular'));
    return MovieResponse.fromJson(json.decode(response.body)).movieList;
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await client.get(Uri.parse('$baseUrl/movie/top_rated'));
    return MovieResponse.fromJson(json.decode(response.body)).movieList;
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/movie?query=$query'),
    );
    return MovieResponse.fromJson(json.decode(response.body)).movieList;
  }
}
