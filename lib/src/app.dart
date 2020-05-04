import 'package:flutter/material.dart';
import 'package:moviesdb/src/localization/localizations.dart';
import 'package:moviesdb/src/ui/movies_list_screen.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizationsDelegate(),
      ],
      home: Scaffold(
        body: MoviesListScreen(),
      ),
    );
  }
}
