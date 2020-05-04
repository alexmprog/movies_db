import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayerScreen extends StatefulWidget {
  final String name;
  final String id;

  YoutubeVideoPlayerScreen({@required this.name, @required this.id, Key key})
      : super(key: key);

  @override
  _YoutubeVideoPlayerScreenState createState() =>
      _YoutubeVideoPlayerScreenState(name, id);
}

class _YoutubeVideoPlayerScreenState extends State<YoutubeVideoPlayerScreen> {
  final String name;
  final String id;
  YoutubePlayerController _controller;

  _YoutubeVideoPlayerScreenState(this.name, this.id);

  @override
  void initState() {
    _controller = _controller = YoutubePlayerController(
      initialVideoId: id,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bottomActions: [
              CurrentPosition(),
              Expanded(child: ProgressBar(controller: _controller), flex: 1),
              RemainingDuration(),
              FullScreenButton()
            ]));
  }
}
