import 'package:core/core.dart';

const tableName = 'tbl_watchlist_tv';

const createTable = '''
  CREATE TABLE  $tableName (
    id INTEGER PRIMARY KEY,
    title TEXT,
    overview TEXT,
    posterPath TEXT
  );
''';


const tableTv = CreateTableContract(
  tableName: tableName,
  tableQuery: createTable,
);
