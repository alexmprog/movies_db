import 'package:flutter/material.dart';
import 'package:moviesdb/src/blocs/bloc_provider.dart';
import 'package:moviesdb/src/blocs/movie_details_bloc.dart';
import 'package:moviesdb/src/blocs/movies_list_bloc.dart';
import 'package:moviesdb/src/localization/localizations.dart';
import 'package:moviesdb/src/model/movies_list.dart';
import 'movie_details_screen.dart';

class MoviesListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MoviesListState();
  }
}

class MoviesListState extends State<MoviesListScreen> {

  MoviesListBloc _bloc;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = MoviesListBloc();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _bloc.fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.popularMovies),
      ),
      body: StreamBuilder(
        stream: _bloc.allMovies,
        builder: (context, AsyncSnapshot<MoviesList> snapshot) {
          if (snapshot.hasData) {
            return _buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildList(AsyncSnapshot<MoviesList> snapshot) {
    return GridView.builder(
        controller: _scrollController,
        itemCount: snapshot.data.results.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: InkResponse(
              enableFeedback: true,
              child: Hero(
                tag: 'movie_${snapshot.data.results[index].id.toString()}',
                child: Image.network(
                  Movie.getImageUrl(snapshot.data.results[index].poster_path),
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () =>
                  _openDetailScreen(context, snapshot.data.results[index]),
            ),
          );
        });
  }

  _openDetailScreen(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return BlocProvider<MovieDetailsBloc>(
          bloc: MovieDetailsBloc(movie),
          child: MovieDetailsScreen(),
        );
      }),
    );
  }
}
