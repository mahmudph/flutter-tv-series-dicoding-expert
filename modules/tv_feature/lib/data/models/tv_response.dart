import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:tv_feature/data/models/tv_model.dart';

class TvResponse extends Equatable {
  const TvResponse({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });

  final int page;
  final List<TvModel> results;
  final int totalResults;
  final int totalPages;

  factory TvResponse.fromJson(String str) => TvResponse.fromMap(
        json.decode(str),
      );

  String toJson() => json.encode(toMap());

  factory TvResponse.fromMap(Map<String, dynamic> json) => TvResponse(
        page: json["page"],
        results: List<TvModel>.from(
          json["results"].map(
            (x) => TvModel.fromMap(x),
          ),
        ),
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(
          results.map(
            (x) => x.toMap(),
          ),
        ),
        "total_results": totalResults,
        "total_pages": totalPages,
      };

  @override
  List<Object?> get props => [
        page,
        results,
        totalResults,
        totalPages,
      ];
}
