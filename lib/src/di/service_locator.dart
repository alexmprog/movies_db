import 'package:get_it/get_it.dart';
import 'package:http/http.dart' show Client;
import 'package:moviesdb/src/data/movies_db_api.dart';
import 'package:moviesdb/src/envs.dart';

GetIt locator = GetIt.instance;

void setupLocator(EnvConfig envConfig) {
  // register env
  locator.registerSingleton<EnvConfig>(envConfig);
  // register network
  locator.registerFactory<Client>(() => Client());
  locator.registerLazySingleton<MoviesDbApi>(() => MoviesDbApi());
}
