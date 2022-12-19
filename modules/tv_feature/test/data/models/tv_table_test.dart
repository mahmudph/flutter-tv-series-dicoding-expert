import 'package:flutter_test/flutter_test.dart';
import 'package:tv_feature/data/models/tv_table.dart';
import 'package:tv_feature/domain/entitas/tv.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group(
    'test tv table',
    () {
      test(
        'should parse from entity to tv table successfuly',
        () {
          /// actual
          var actual = TvTable.fromEntity(testTvDetail);

          expect(actual.id, testTvTable.id);
          expect(actual.title, testTvTable.title);
          expect(actual.overview, testTvTable.overview);
          expect(actual.posterPath, testTvTable.posterPath);
        },
      );

      test(
        'should parse from map to tv table successfuly',
        () {
          /// actual
          var actual = TvTable.fromMap(testTvMap);

          expect(actual.id, testTvTable.id);
          expect(actual.title, testTvTable.title);
          expect(actual.overview, testTvTable.overview);
          expect(actual.posterPath, testTvTable.posterPath);
        },
      );

      test(
        'should parse from model to tv table as map successfuly',
        () {
          /// actual
          var actual = testTvTable.toJson();

          expect(actual['id'], testTvTable.id);
          expect(actual['title'], testTvTable.title);
          expect(actual['overview'], testTvTable.overview);
          expect(actual['posterPath'], testTvTable.posterPath);
        },
      );

      test(
        'should parse from tv model to entyty',
        () {
          /// actual
          var actual = testTvTable.toEntity();
          var expected = Tv.watchlist(
            name: 'name',
            id: 1,
            overview: 'overview',
            posterPath: 'posterPath',
          );

          expect(actual.id, expected.id);
          expect(actual.name, expected.name);
          expect(actual.overview, expected.overview);
          expect(actual.posterPath, expected.posterPath);
        },
      );
    },
  );
}
