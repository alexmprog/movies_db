import 'dart:io';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:moviesdb/src/data/movies_db_api.dart';
import 'package:moviesdb/src/data/result.dart';
import 'package:moviesdb/src/di/service_locator.dart';
import 'package:moviesdb/src/envs.dart';
import 'package:moviesdb/src/model/movies_list.dart';
import 'package:moviesdb/src/model/trailers_list.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  var mockClient = _MockClient();
  var env = EnvConfig(
      env: Env.DEV, baseUrl: 'http://fake.server.com', apiKey: 'fake-api-key');

  group("MoviesDb Api test", () {
    setUp(() {
      locator.registerSingleton<EnvConfig>(env);
      locator.registerFactory<Client>(() => mockClient);
    });

    tearDown(() {
      locator.reset();
    });

    test("fetchMoviesList success test", () async {
      var api = MoviesDbApi();
      when(mockClient.get(
              "http://fake.server.com/popular?api_key=fake-api-key&page=1"))
          .thenAnswer((_) async => http.Response(
              '{"page": 1,"total_results":10000,"total_pages": 500,"results":[{"popularity": 474.053,"vote_count":1337,"video":false,"poster_path":"/wlfDxbGEsW58vGhFljKkcR5IxDj.jpg","id":545609,"adult":false,"backdrop_path":"/1R6cvRtZgsYCkh8UFuWFN33xBP4.jpg",' +
                  '"original_language":"en","original_title":"Extraction","genre_ids":[28,18,53],"title":"Extraction","vote_average":7.5,"overview":"Tyler Rake, a fearless mercenary who offers his services on the black market, embarks on a dangerous mission when he is hired to rescue the kidnapped son of a Mumbai crime lord…","release_date": "2020-04-24"},{"popularity": 109.352,"vote_count":12080,"video":false,"poster_path": "/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg","id":475557,"adult":false,"backdrop_path":"/f5F4cRhQdUbyVbB5lTNCwUzD6BP.jpg","original_language":"en","original_title":"Joker","genre_ids":[80,18,53],"title":"Joker","vote_average":8.2,' +
                  '"overview":"During the 1980s,a failed stand-up comedian is driven insane and turns to a life of crime and chaos in Gotham City while becoming an infamous psychopathic crime figure.","release_date":"2019-10-02"}]}',
              200,
              headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'}));
      expect(await api.fetchMoviesList(1),
          isInstanceOf<SuccessResult<MoviesList>>());
    });

    test("fetchMoviesList fail test", () async {
      var api = MoviesDbApi();
      when(mockClient.get(
              "http://fake.server.com/popular?api_key=fake-api-key&page=1"))
          .thenAnswer((_) async => http.Response(
                  '{"status_code":8,"status_message":"Invalid API key: You must be granted a valid key.","success":false}',
                  401,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8'
                  }));
      expect(await api.fetchMoviesList(1), isInstanceOf<ErrorResult>());
    });

    test("fetchTrailersList success test", () async {
      var api = MoviesDbApi();
      when(mockClient
              .get("http://fake.server.com/1/videos?api_key=fake-api-key"))
          .thenAnswer((_) async => http.Response(
                  '{"id": 419704,"results":[{"id":"5cf81bfb92514153b7b9e733","iso_639_1":"en","iso_3166_1": "US","key":"P6AaSMfXHbA","name":"Official Trailer #1","site":"YouTube","size":1080,"type":"Trailer"},{"id":"5d313d7c326c1900101eba51","iso_639_1":"en","iso_3166_1":"US","key":"nxi6rtBtBM0","name":"Official Trailer#2","site":"YouTube","size":2160,"type":"Trailer"},{"id":"5d894d8a79b3d4001f832e8d","iso_639_1": "en","iso_3166_1":"US","key": "t6g0dsQzfqY","name": "Official Trailer #3","site": "YouTube","size": 1080,"type":"Trailer"},{"id":"5d894d21d9f4a6000e4dc169","iso_639_1":"en","iso_3166_1":"US","key":"stOVFXuyyWQ","name": "Moon Rover","site": "YouTube","size": 1080,"type": "Clip"},{"id":"5d894d5179b3d4002782dd61","iso_639_1":"en","iso_3166_1":"US","key":"Nvb9cDDFHtk","name":"Lima Project","site":"YouTube","size": 1080,"type": "Clip"},{"id":"5d894d5cd9f4a600204da4ea","iso_639_1":"en","iso_3166_1":"US","key":"ykC_wu6ffOU","name": "Antenna","site": "YouTube","size": 1080,"type": "Clip"}]}',
                  200,
                  headers: {
                    HttpHeaders.contentTypeHeader:
                        'application/json; charset=utf-8'
                  }));
      expect(await api.fetchTrailersList(1),
          isInstanceOf<SuccessResult<TrailersList>>());
    });

    test("fetchTrailersList fail test", () async {
      var api = MoviesDbApi();
      when(mockClient.get(
          "http://fake.server.com/1/videos?api_key=fake-api-key"))
          .thenAnswer((_) async => http.Response(
          '{"status_code":8,"status_message":"Invalid API key: You must be granted a valid key.","success":false}',
          401,
          headers: {
            HttpHeaders.contentTypeHeader:
            'application/json; charset=utf-8'
          }));
      expect(await api.fetchTrailersList(1), isInstanceOf<ErrorResult>());
    });
  });
}
