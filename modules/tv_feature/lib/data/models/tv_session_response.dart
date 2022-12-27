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
    required this.seasonNumber,
    this.posterPath,
  });

  final int id;
  final String? airDate;
  final List<EpisodeModel> episodes;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  factory TvSessionResponse.fromJson(String str) =>
      TvSessionResponse.fromMap(json.decode(str));

  factory TvSessionResponse.fromMap(Map<String, dynamic> json) =>
      TvSessionResponse(
        id: json["id"],
        airDate: json["air_date"],
        episodes: List<EpisodeModel>.from(
          json["episodes"].map(
            (x) => EpisodeModel.fromMap(x),
          ),
        ),
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toMap() => {
        "air_date": airDate,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toMap())),
        "name": name,
        "overview": overview,
        "id": id,
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
      seasonNumber: seasonNumber,
      posterPath: posterPath,
    );
  }
}
