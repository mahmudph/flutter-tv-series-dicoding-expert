import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/session.dart';
import 'package:ditonton/presentation/widgets/tv_seasson_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
    );
  }

  testWidgets(
    "Should tv session data information with correct value",
    (tester) async {
      final tvSeasson = TvSeasson(
        season: Season(
          airDate: '2022-12-02',
          episodeCount: 12,
          id: 123,
          name: 'loko',
          overview: 'Reprehenderit occaecat minim elit fugiat officia pariatur',
          posterPath: 'poster path',
          seasonNumber: 2,
        ),
        defaultPosterPath: "default",
      );

      await tester.pumpWidget(_makeTestableWidget(tvSeasson));

      var cachedImageTv = find.byType(CachedNetworkImage);
      var cachedImageTvValue = tester.widget<CachedNetworkImage>(cachedImageTv);
      var sessionName = find.text(tvSeasson.season.name);
      var sessionNameValue = tester.widget<Text>(sessionName);

      expect(sessionName, findsOneWidget);
      expect(sessionNameValue.maxLines, 1);
      expect(sessionNameValue.overflow, TextOverflow.ellipsis);
      expect(sessionNameValue.textAlign, TextAlign.center);

      expect(cachedImageTv, findsOneWidget);
      expect(cachedImageTvValue.width, equals(90));

      expect(
        cachedImageTvValue.imageUrl,
        equals(
          '$BASE_IMAGE_URL${tvSeasson.season.posterPath}',
        ),
      );
    },
  );
}
