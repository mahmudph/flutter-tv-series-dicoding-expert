import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tv_feature/data/datasources/tv_local_data_source.dart';
import 'package:tv_feature/data/datasources/tv_remote_data_source.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';

class MockTvRepository extends Mock implements TvRepository {}

class MockTvRemoteDataSource extends Mock implements TvRemoteDataSource {}

class MockTvLocalDataSource extends Mock implements TvLocalDataSource {}

class MockHttpClient extends Mock implements http.Client {}

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

class MockDatabase extends Mock implements Database {}
