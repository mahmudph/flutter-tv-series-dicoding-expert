import 'package:core/core.dart';
import 'package:movie_feature/data/models/movie_table.dart';

import 'commons/constrains.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);
  Future<String> removeWatchlist(MovieTable movie);
  Future<MovieTable?> getMovieById(int id);
  Future<List<MovieTable>> getWatchlistMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelper databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      final db = await databaseHelper.database;
      await db!.insert(tableName, movie.toJson());
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    try {
      final db = await databaseHelper.database;
      await db!.delete(tableName, where: 'id = ?', whereArgs: [movie.id]);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final db = await databaseHelper.database;
    final results = await db!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? MovieTable.fromMap(results.first) : null;
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies() async {
    final db = await databaseHelper.database;
    final results = await db!.query(tableName);
    return results.map((data) => MovieTable.fromMap(data)).toList();
  }
}
