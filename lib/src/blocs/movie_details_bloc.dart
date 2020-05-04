import 'package:moviesdb/src/blocs/bloc_provider.dart';
import 'package:moviesdb/src/data/movies_db_api.dart';
import 'package:moviesdb/src/data/result.dart';
import 'package:moviesdb/src/di/service_locator.dart';
import 'package:moviesdb/src/model/movies_list.dart';
import 'package:moviesdb/src/model/trailers_list.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailsBloc implements BlocBase {
  final Movie _movie;
  final _moviesDbApi = locator<MoviesDbApi>();

  // return only youtube trailers
  final _trailersFetcher = BehaviorSubject<List<Trailer>>();

  Stream<List<Trailer>> get movieTrailers => _trailersFetcher.stream;

  MovieDetailsBloc(this._movie) {
    _fetchTrailers(_movie.id);
  }

  _fetchTrailers(int movieId) async {
    Result result = await _moviesDbApi.fetchTrailersList(movieId);
    if (result is SuccessResult) {
      TrailersList list = result.value;
      _trailersFetcher.sink
          .add(list.results.where((t) => t.site == "YouTube").toList());
    } else if (result is ErrorResult) {
      _trailersFetcher.addError(result.error);
    }
  }

  @override
  dispose() async {
    await _trailersFetcher.drain();
    _trailersFetcher.close();
  }

  String get title => _movie.title;

  String get posterUrl => _movie.poster_path;

  String get description => _movie.overview;

  String get releaseDate => _movie.release_date;

  String get voteAverage => _movie.vote_average.toString();

  int get movieId => _movie.id;
}
