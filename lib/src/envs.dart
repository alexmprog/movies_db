import 'package:flutter/cupertino.dart';

enum Env {
  DEV // put others envs here
}

class EnvConfig {
  final Env env;
  final String baseUrl;
  final String apiKey;

  EnvConfig(
      {@required this.env, @required this.baseUrl, @required this.apiKey});
}
