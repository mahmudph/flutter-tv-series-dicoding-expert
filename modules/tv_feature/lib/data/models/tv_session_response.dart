import 'dart:convert';
import 'package:tv_feature/domain/entitas/tv_session.dart';
import 'tv_episode.dart';

class TvSessionResponse {
  TvSessionResponse({
    required this.id,
    required this.episodes,
    required this.airDate,
    required this.name,
    required this.overview,
    required this.tvSessionResponseId,
    required this.seasonNumber,
    this.posterPath,
  });

  final String id;
  final String airDate;
  final List<EpisodeModel> episodes;
  final String name;
  final String overview;
  final int tvSessionResponseId;
  final String? posterPath;
  final int seasonNumber;

  factory TvSessionResponse.fromJson(String str) =>
      TvSessionResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TvSessionResponse.fromMap(Map<String, dynamic> json) =>
      TvSessionResponse(
        id: json["_id"],
        airDate: json["air_date"],
        episodes: List<EpisodeModel>.from(
          json["episodes"].map(
            (x) => EpisodeModel.fromMap(x),
          ),
        ),
        name: json["name"],
        overview: json["overview"],
        tvSessionResponseId: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "air_date": airDate,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toMap())),
        "name": name,
        "overview": overview,
        "id": tvSessionResponseId,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  TvSession toEntity() {
    return TvSession(
      id: id,
      episodes: episodes.map((e) => e.toEntity()).toList(),
      airDate: airDate,
      name: name,
      overview: overview,
      tvSessionResponseId: tvSessionResponseId,
      seasonNumber: seasonNumber,
    );
  }
}
