import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:core/commons/exception.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/mocks.dart';

void main() {
  late MockDatabase mockDatabase;
  late MovieLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabase = MockDatabase();
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group(
    'save watchlist',
    () {
      test(
        'should return success message when insert to database is success',
        () async {
          // arrange
          when(() => mockDatabase.insert(tableName, testMovieTable.toJson()))
              .thenAnswer(
            (_) async => 1,
          );
          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => mockDatabase,
          );
          // act
          final result = await dataSource.insertWatchlist(testMovieTable);
          // assert
          expect(result, 'Added to Watchlist');
        },
      );

      test(
        'should throw DatabaseException when insert to database is failed',
        () async {
          // arrange
          when(
            () => mockDatabase.delete(
              tableName,
              where: 'id = ?',
              whereArgs: [testMovieTable.id],
            ),
          ).thenAnswer((_) async => 1);

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => mockDatabase,
          );
          // act
          final call = dataSource.insertWatchlist(testMovieTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        },
      );
    },
  );

  group(
    'remove watchlist',
    () {
      test(
        'should return success message when remove from database is success',
        () async {
          // arrange
          when(
            () => mockDatabase.delete(
              tableName,
              where: 'id = ?',
              whereArgs: [testMovieTable.id],
            ),
          ).thenAnswer((_) async => 1);

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => mockDatabase,
          );

          // act
          final result = await dataSource.removeWatchlist(testMovieTable);
          // assert
          expect(result, 'Removed from Watchlist');
        },
      );

      test(
        'should throw DatabaseException when remove from database is failed',
        () async {
          // arrange
          when(
            () => mockDatabase.delete(
              tableName,
              where: 'id = ?',
              whereArgs: [testMovieTable.id],
            ),
          ).thenThrow(DatabaseException(''));

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => mockDatabase,
          );
          // act
          final call = dataSource.removeWatchlist(testMovieTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        },
      );
    },
  );

  group(
    'Get Movie Detail By Id',
    () {
      const tId = 1;

      test('should return Movie Detail Table when data is found', () async {
        // arrange
        when(
          () => mockDatabase.query(
            tableName,
            where: 'id = ?',
            whereArgs: [tId],
          ),
        ).thenAnswer((_) async => [testMovieMap]);

        when(() => mockDatabaseHelper.database).thenAnswer(
          (_) async => mockDatabase,
        );

        // act
        final result = await dataSource.getMovieById(tId);
        // assert
        expect(result, testMovieTable);
      });

      test(
        'should return null when data is not found',
        () async {
          // arrange
          when(
            () => mockDatabase.query(
              tableName,
              where: 'id = ?',
              whereArgs: [tId],
            ),
          ).thenAnswer((_) async => []);

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => mockDatabase,
          );
          // act
          final result = await dataSource.getMovieById(tId);
          // assert
          expect(result, null);
        },
      );
    },
  );

  group(
    'get watchlist movies',
    () {
      test(
        'should return list of MovieTable from database',
        () async {
          // arrange
          when(() => mockDatabase.query(tableName)).thenAnswer(
            (_) async => [testMovieMap],
          );

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => mockDatabase,
          );

          // act
          final result = await dataSource.getWatchlistMovies();
          // assert
          expect(result, [testMovieTable]);
        },
      );
    },
  );
}
