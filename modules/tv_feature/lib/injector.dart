import 'package:get_it/get_it.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/datasources/tv_local_data_source.dart';
import 'data/datasources/tv_remote_data_source.dart';

final locator = GetIt.instance;

void initialize() {
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(
      client: locator(),
      baseUrl: dotenv.env['API_KEY']!,
    ),
  );

  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(
      databaseHelper: locator(),
    ),
  );
}
