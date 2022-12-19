import 'package:core/db/database_helper.dart';
import 'package:tv_feature/data/models/tv_table.dart';
import 'package:tv_feature/data/datasources/commons/constrains.dart';

abstract class TvLocalDataSource {
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTvs();
  Future<String> insertWatchlistTv(TvTable tv);
  Future<String> removeWatchlistTv(TvTable tv);
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelper databaseHelper;

  TvLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlistTv(TvTable tv) async {
    final db = await databaseHelper.database;
    await db!.insert(tableName, tv.toJson());
    return 'Added to Watchlist';
  }

  @override
  Future<String> removeWatchlistTv(TvTable movie) async {
    final db = await databaseHelper.database;

    await db!.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [movie.id],
    );

    return 'Removed from Watchlist';
  }

  @override
  Future<TvTable?> getTvById(int id) async {
    final db = await databaseHelper.database;

    final results = await db!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? TvTable.fromMap(results.first) : null;
  }

  @override
  Future<List<TvTable>> getWatchlistTvs() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> result = await db!.query(tableName);
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
