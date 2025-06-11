import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'injector.dart';

var getIt = GetIt.instance;

Future<void> configureInjector() async {
  // HIVE
  var box = await Hive.openBox('news_box');
  getIt.registerLazySingleton(
    () => box,
  );

  // CHECK CONNECTIVITY
  getIt.registerLazySingleton(() => ConnectivityService());
  getIt<ConnectivityService>().initialize();

  // HTTP
  getIt.registerLazySingleton(
    () => http.Client(),
  );

  /// FEATURE - NEWS
  // BLOC
  getIt.registerFactory(
    () => NewsBloc(
      getNewsByCategory: getIt(),
      getAllNews: getIt(),
    ),
  );

  // BLOC - SEARCH NEWS
  getIt.registerFactory(
    () => SearchNewsBloc(
      getSearchNews: getIt(),
    ),
  );

  // USE CASE
  getIt.registerLazySingleton(
    () => GetNewsByCategory(newsRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetAllNews(newsRepository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetSearchNews(newsRepository: getIt()),
  );

  // REPOSITORY
  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      newsRemoteDatasources: getIt(),
      newsLocalDatasources: getIt(),
      box: getIt(),
    ),
  );

  // DATA SOURCE
  getIt.registerLazySingleton<NewsLocalDatasources>(
    () => NewsLocalDataImpl(
      box: getIt(),
    ),
  );
  getIt.registerLazySingleton<NewsRemoteDatasources>(
    () => NewsRemoteDataImpl(
      client: getIt(),
    ),
  );
}
