import 'package:core/core.dart';

const tableName = 'tbl_watchlist_movie';

const createTable = '''
  CREATE TABLE  $tableName (
    id INTEGER PRIMARY KEY,
    title TEXT,
    overview TEXT,
    posterPath TEXT
  );
''';

const tableMovie = CreateTableContract(
  tableName: tableName,
  tableQuery: createTable,
);
