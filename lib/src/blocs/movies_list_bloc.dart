import 'package:moviesdb/src/blocs/bloc_provider.dart';
import 'package:moviesdb/src/data/movies_db_api.dart';
import 'package:moviesdb/src/data/result.dart';
import 'package:moviesdb/src/di/service_locator.dart';
import 'package:moviesdb/src/model/movies_list.dart';
import 'package:rxdart/rxdart.dart';

class MoviesListBloc implements BlocBase {
  final _moviesDbApi = locator<MoviesDbApi>();
  final _moviesFetcher = BehaviorSubject<MoviesList>();

  int totalPages = 1;
  int nextPage = 1;
  int lastLoadedPage = 0;

  Stream<MoviesList> get allMovies => _moviesFetcher.stream;

  MoviesListBloc() {
    fetchNextPage();
  }

  fetchNextPage() async {
    if (lastLoadedPage == nextPage) return;
    if (lastLoadedPage < nextPage) {
      lastLoadedPage++;
    }
    if (lastLoadedPage <= totalPages) {
      Result result = await _moviesDbApi.fetchMoviesList(lastLoadedPage);
      if (result is SuccessResult) {
        MoviesList list = result.value;
        if (_moviesFetcher.value == null) {
          totalPages = list.total_pages;
          _moviesFetcher.sink.add(list);
          nextPage++;
        } else {
          _moviesFetcher.value.results.addAll(list.results);
          _moviesFetcher.sink.add(_moviesFetcher.value);
          nextPage++;
        }
      } else if (result is ErrorResult) {
        _moviesFetcher.addError(result.error);
      }
    }
  }

  @override
  dispose() {
    _moviesFetcher.close();
  }
}
