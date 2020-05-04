import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:moviesdb/src/data/result.dart';
import 'package:moviesdb/src/di/service_locator.dart';
import 'package:moviesdb/src/envs.dart';
import 'package:moviesdb/src/model/movies_list.dart';
import 'package:moviesdb/src/model/trailers_list.dart';

class MoviesDbApi {
  Client _client = locator<Client>();
  EnvConfig _envConfig = locator<EnvConfig>();

  Future<Result> fetchMoviesList(int page) async {
    Response response;
    if (_envConfig.apiKey != null && _envConfig.apiKey.isNotEmpty) {
      response = await _client.get(
          "${_envConfig.baseUrl}/popular?api_key=${_envConfig.apiKey}&page=$page");
    } else {
      return Result<String>.error('Please add your API key');
    }
    if (response.statusCode == 200) {
      return Result<MoviesList>.success(MoviesList.fromJson(json.decode(response.body)));
    } else {
      return Result<String>.error('Failed to load movies');
    }
  }

  Future<Result> fetchTrailersList(int movieId) async {
    Response response;
    if (_envConfig.apiKey != null && _envConfig.apiKey.isNotEmpty) {
      response = response = await _client.get(
          "${_envConfig.baseUrl}/$movieId/videos?api_key=${_envConfig.apiKey}");
    } else {
      return Result<String>.error('Please add your API key');
    }
    if (response.statusCode == 200) {
      return Result<TrailersList>.success(TrailersList.fromJson(json.decode(response.body)));
    } else {
      return Result<String>.error('Failed to load trailers');
    }
  }
}
