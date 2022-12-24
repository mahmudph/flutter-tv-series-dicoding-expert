import 'package:core/db/database_helper.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockDatabase extends Mock implements Database {}

class MockMovieRepository extends Mock implements MovieRepository {}

class MockMovieRepositoryImpl extends Mock implements MovieRepository {}

class MockMovieLocalDataSource extends Mock implements MovieLocalDataSource {}

class MockMovieRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockHttpClient extends Mock implements Client {}
