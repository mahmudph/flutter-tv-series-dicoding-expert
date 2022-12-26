import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tv_feature/domain/entitas/episode.dart';

class EpisodeModel extends Equatable {
  const EpisodeModel({
    required this.id,
    required this.episodeNumber,
    required this.airDate,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.seasonNumber,
    required this.voteAverage,
    required this.voteCount,
    this.stillPath,
  });

  final String airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final String? productionCode;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

  factory EpisodeModel.fromJson(String str) =>
      EpisodeModel.fromMap(json.decode(str));

  factory EpisodeModel.fromMap(Map<String, dynamic> json) => EpisodeModel(
        airDate: json["air_date"],
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        productionCode: json["production_code"],
        seasonNumber: json["season_number"],
        stillPath: json["still_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toMap() => {
        "air_date": airDate,
        "episode_number": episodeNumber,
        "id": id,
        "name": name,
        "overview": overview,
        "production_code": productionCode,
        "season_number": seasonNumber,
        "still_path": stillPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };

  Episode toEntity() {
    return Episode(
      id: id,
      episodeNumber: episodeNumber,
      airDate: airDate,
      name: name,
      overview: overview,
      productionCode: productionCode,
      seasonNumber: seasonNumber,
      voteAverage: voteAverage,
      voteCount: voteCount,
      stillPath: stillPath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        episodeNumber,
        airDate,
        name,
        overview,
        productionCode,
        seasonNumber,
        stillPath,
        voteAverage,
        voteCount,
      ];
}
