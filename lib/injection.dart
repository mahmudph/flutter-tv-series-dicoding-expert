import 'dart:io';

import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get_it/get_it.dart';
import 'package:http/io_client.dart';
import 'package:tv_feature/tv_feature.dart';
import 'package:movie_feature/movie_feature.dart';
import 'package:core/networks/http_log_interceptor.dart';
import 'package:tv_feature/domain/repositories/tv_repository.dart';
import 'package:tv_feature/presentation/bloc/tv_details/tv_details_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_interceptor/http_interceptor.dart';

final locator = GetIt.instance;

void init(SecurityContext securityContext) {
  // provider
  locator.registerFactory(
    () => RecommendationMoviesCubit(
      getMovieRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailCubit(
      movieDetail: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchMovieCubit(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMovieCubit(
      popularMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesCubit(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => NowPlayingMovieCubit(
      getNowPlayingMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieCubit(
      getWatchlistMovies: locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistMovieStatusCubit(
      getWatchListStatus: locator(),
      removeWatchlist: locator(),
      saveWatchlist: locator(),
    ),
  );

  locator.registerFactory(
    () => TvTopRatedCubit(
      getTopRatedTv: locator(),
    ),
  );

  locator.registerFactory(
    () => TvDetailsCubit(
      getTvDetail: locator(),
    ),
  );

  locator.registerFactory(
    () => TvRecomendationsCubit(
      tvRecommendations: locator(),
    ),
  );

  locator.registerFactory(
    () => TvPopularsCubit(
      getPopularTv: locator(),
    ),
  );

  locator.registerFactory(
    () => TvOnTheAirCubit(
      getOnTheAirTvShow: locator(),
    ),
  );

  locator.registerFactory(
    () => TvSearchCubit(
      searchTv: locator(),
    ),
  );

  locator.registerFactory(
    () => TvWatchlistCubit(
      getWatchlistTv: locator(),
    ),
  );

  locator.registerFactory(
    () => TvWatchlistStatusCubit(
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(
    () => TvSessionCubit(getTvSession: locator()),
  );

  locator.registerFactory(
    () => TvSessionEpisodeCubit(getTvSessionEpisode: locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetOnTheAirTVShows(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchListTvStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetTvSession(locator()));
  locator.registerLazySingleton(() => GetTvSessionEpisode(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(
      client: locator<InterceptedClient>(),
      baseUrl: dotenv.env['BASE_URL']!,
    ),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(
      databaseHelper: locator(),
    ),
  );

  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(
      client: locator<InterceptedClient>(),
      baseUrl: dotenv.env["BASE_URL"]!,
    ),
  );

  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(
      databaseHelper: locator(),
    ),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(
      tableBuilder: [tableTv, tableMovie],
    ),
  );

  locator.registerLazySingleton<IOClient>(
    () {
      final httpClient = HttpClient(context: securityContext);
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;
      return IOClient(httpClient);
    },
  );

  // external
  locator.registerLazySingleton<InterceptedClient>(
    () => InterceptedClient.build(
      requestTimeout: const Duration(seconds: 10),
      client: locator<IOClient>(),
      interceptors: [
        AppInterceptor(
          apiKey: dotenv.env['API_KEY']!,
        ),
        AppLogInterceptor()
      ],
    ),
  );

  locator.registerLazySingleton<FirebaseAnalyticService>(
    () => FirebaseAnalyticService(
      firebaseAnalytics: FirebaseAnalytics.instance,
    ),
  );
}
