import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/commons/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/domain/entitas/session.dart';
import 'package:tv_feature/presentation/widgets/tv_seasson_list.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
    );
  }

  testWidgets(
    "Should tv session data information with correct value",
    (tester) async {
      const tvSeasson = TvSeasson(
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

      await tester.pumpWidget(makeTestableWidget(tvSeasson));

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
          '$baseUrlImage${tvSeasson.season.posterPath}',
        ),
      );
    },
  );
}
