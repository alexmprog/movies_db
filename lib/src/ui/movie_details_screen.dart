import 'package:flutter/material.dart';
import 'package:moviesdb/src/blocs/bloc_provider.dart';
import 'package:moviesdb/src/blocs/movie_details_bloc.dart';
import 'package:moviesdb/src/localization/localizations.dart';
import 'package:moviesdb/src/model/movies_list.dart';
import 'package:moviesdb/src/model/trailers_list.dart';
import 'package:moviesdb/src/ui/youtube_video_player_screen.dart';

class MovieDetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieDetailsBloc>(context);
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  elevation: 0.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: 'movie_${bloc.movieId.toString()}',
                      child: Image.network(
                        Movie.getImageUrl(bloc.posterUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      bloc.title,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 1.0, right: 1.0),
                          ),
                          Text(
                            bloc.voteAverage,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10.0, right: 10.0),
                          ),
                          Text(
                            bloc.releaseDate,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                      Text(bloc.description),
                      Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                      Text(
                        localizations.youtubeTrailers,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                      StreamBuilder(
                        stream: bloc.movieTrailers,
                        builder:
                            (context, AsyncSnapshot<List<Trailer>> snapshot) {
                          if (!snapshot.hasError) {
                            if (snapshot.hasData) {
                              if (snapshot.data.length > 0)
                                return _trailerLayout(snapshot.data);
                              else
                                return Center(
                                  child: Container(
                                    child:
                                    Text(localizations.noTrailerAvailable),
                                  ),
                                );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          } else {
                            return Center(
                              child: Container(
                                child: Text(localizations.noTrailerAvailable),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _trailerLayout(List<Trailer> data) {
    return Container(
        margin: EdgeInsets.all(5.0),
        height: 108.0,
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.transparent,
              height: 4.0,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final trailer = data[index];
              return Padding(
                  padding: EdgeInsets.all(4.0),
                  child: InkResponse(
                    enableFeedback: true,
                    child: Container(
                      width: 132.0,
                      color: Colors.grey,
                      padding: EdgeInsets.all(4.0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Image.network(
                                    Trailer.getYoutubeImageUrl(trailer.key),
                                    fit: BoxFit.cover,
                                  ),
                                  Icon(Icons.play_circle_filled)
                                ],
                              ),
                            ),
                            flex: 1,
                          ),
                          Text(
                            trailer.name,
                            maxLines: 1,
                            style: TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return YoutubeVideoPlayerScreen(
                                name: trailer.name, id: trailer.key);
                          }));
                    },
                  ));
            }));
  }
}
