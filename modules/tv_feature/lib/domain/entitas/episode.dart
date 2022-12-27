import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  const Episode({
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

  final String? airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final String? productionCode;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

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
