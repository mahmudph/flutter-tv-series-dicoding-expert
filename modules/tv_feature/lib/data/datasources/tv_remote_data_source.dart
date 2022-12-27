import 'package:tv_feature/data/models/tv_detail_response.dart';
import 'package:tv_feature/data/models/tv_episode.dart';
import 'package:tv_feature/data/models/tv_model.dart';
import 'package:tv_feature/data/models/tv_response.dart';
import 'package:http/http.dart' as http;
import 'package:tv_feature/data/models/tv_session_response.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getOnTheAirTVShows();
  Future<List<TvModel>> getPopularTvs();
  Future<List<TvModel>> getTopRatedTvs();
  Future<TvDetailResponse> getTvDetail(int id);
  Future<List<TvModel>> getTvRecommendations(int id);
  Future<List<TvModel>> searchTvs(String query);
  Future<TvSessionResponse> getTvSession(int tvId, int tvSessionId);
  Future<EpisodeModel> getSessionEpisode(
    int tvId,
    int tvSessionId,
    int tvSessionEpisodeId,
  );
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  TvRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<List<TvModel>> getOnTheAirTVShows() async {
    final response = await client.get(Uri.parse('$baseUrl/tv/on_the_air'));
    return TvResponse.fromJson(response.body).results;
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id'));
    return TvDetailResponse.fromJson(response.body);
  }

  @override
  Future<List<TvModel>> getTvRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$id/recommendations'),
    );
    return TvResponse.fromJson(response.body).results;
  }

  @override
  Future<List<TvModel>> getPopularTvs() async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/popular'),
    );
    return TvResponse.fromJson(response.body).results;
  }

  @override
  Future<List<TvModel>> getTopRatedTvs() async {
    final response = await client.get(Uri.parse('$baseUrl/tv/top_rated'));
    return TvResponse.fromJson(response.body).results;
  }

  @override
  Future<List<TvModel>> searchTvs(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/tv?query=$query'),
    );
    return TvResponse.fromJson(response.body).results;
  }

  @override
  Future<TvSessionResponse> getTvSession(int tvId, int tvSessionId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$tvId/season/$tvSessionId'),
    );

    return TvSessionResponse.fromJson(response.body);
  }

  @override
  Future<EpisodeModel> getSessionEpisode(
    int tvId,
    int tvSessionId,
    int tvSessionEpisodeId,
  ) async {
    final response = await client.get(
      Uri.parse(
        '$baseUrl/tv/$tvId/season/$tvSessionId/episode/$tvSessionEpisodeId',
      ),
    );

    return EpisodeModel.fromJson(response.body);
  }
}
