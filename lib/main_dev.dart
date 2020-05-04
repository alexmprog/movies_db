import 'package:flutter/material.dart';
import 'package:moviesdb/src/app.dart';
import 'package:moviesdb/src/di/service_locator.dart';
import 'package:moviesdb/src/envs.dart';

void main() {
  setupLocator(EnvConfig(
      env: Env.DEV,
      baseUrl: 'http://api.themoviedb.org/3/movie',
      apiKey: 'put_api_key_here'));
  runApp(App());
}
