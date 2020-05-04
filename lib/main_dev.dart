import 'package:flutter/material.dart';
import 'package:moviesdb/src/app.dart';
import 'package:moviesdb/src/di/service_locator.dart';
import 'package:moviesdb/src/envs.dart';

void main() {
  setupLocator(EnvConfig(
      env: Env.DEV,
      baseUrl: 'put_api_key_here',
      apiKey: '7fa18afb6da8e1935b605fbde28792a3'));
  runApp(App());
}
