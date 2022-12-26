import 'package:equatable/equatable.dart';

import 'episode.dart';

class TvSession extends Equatable {
  final int id;
  final String airDate;
  final List<Episode> episodes;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  const TvSession({
    required this.id,
    required this.episodes,
    required this.airDate,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    this.posterPath,
  });

  @override
  List<Object?> get props => [
        id,
        episodes,
        airDate,
        name,
        overview,
        seasonNumber,
        posterPath,
      ];
}
