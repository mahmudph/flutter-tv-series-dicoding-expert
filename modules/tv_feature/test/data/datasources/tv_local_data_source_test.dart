import 'package:core/commons/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_feature/data/datasources/commons/constrains.dart';
import 'package:tv_feature/data/datasources/tv_local_data_source.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../mocks/data_mock.dart';

void main() {
  late MockDatabase database;
  late TvLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    database = MockDatabase();
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group(
    'save watchlist',
    () {
      test(
        'should return success message when insert to database is success',
        () async {
          // arrange
          when(() => database.insert(tableName, testTvTable.toJson()))
              .thenAnswer(
            (_) async => 1,
          );
          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => database,
          );

          final result = await dataSource.insertWatchlistTv(testTvTable);
          expect(result, 'Added to Watchlist');
        },
      );

      test(
        'should throw DatabaseException when insert to database is failed',
        () async {
          // arrange
          when(() => database.insert(tableName, testTvTable.toJson()))
              .thenThrow(
            DatabaseException(''),
          );

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => database,
          );
          // act
          final call = dataSource.insertWatchlistTv(testTvTable);
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
            () => database.delete(
              tableName,
              where: 'id = ?',
              whereArgs: [testTvTable.id],
            ),
          ).thenAnswer((_) async => 1);

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => database,
          );

          // act
          final result = await dataSource.removeWatchlistTv(testTvTable);
          // assert
          expect(result, 'Removed from Watchlist');
        },
      );

      test(
        'should throw DatabaseException when remove from database is failed',
        () async {
          // arrange
          when(
            () => database.delete(
              tableName,
              where: 'id = ?',
              whereArgs: [testTvTable.id],
            ),
          ).thenThrow(DatabaseException(''));

          when(() => mockDatabaseHelper.database).thenAnswer(
            (_) async => database,
          );

          // act
          final call = dataSource.removeWatchlistTv(testTvTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        },
      );
    },
  );

  group('Get tv Detail By Id', () {
    const tId = 1;

    test('should return tv Detail Table when data is found', () async {
      // arrange
      when(
        () => database.query(
          tableName,
          where: 'id = ?',
          whereArgs: [tId],
        ),
      ).thenAnswer((_) async => [testTvMap]);

      when(() => mockDatabaseHelper.database).thenAnswer(
        (_) async => database,
      );

      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(
        () => database.query(
          tableName,
          where: 'id = ?',
          whereArgs: [tId],
        ),
      ).thenAnswer((_) async => []);

      when(() => mockDatabaseHelper.database).thenAnswer(
        (_) async => database,
      );

      // act
      final result = await dataSource.getTvById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv show', () {
    test('should return list of TvTable from database', () async {
      // arrange
      when(() => database.query(tableName)).thenAnswer(
        (_) async => [testTvMap],
      );

      when(() => mockDatabaseHelper.database).thenAnswer(
        (_) async => database,
      );

      final result = await dataSource.getWatchlistTvs();
      // assert
      expect(result, [testTvTable]);
    });
  });
}
