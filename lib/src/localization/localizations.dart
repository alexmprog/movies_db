import 'dart:async';

import 'package:flutter/material.dart';

class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
  }

  String get popularMovies => "Popular movies";

  String get youtubeTrailers => "Youtube trailers";

  String get noTrailerAvailable => "No trailer available";
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  Future<AppLocalizations> load(Locale locale) =>
      Future(() => AppLocalizations());

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode.toLowerCase().contains('en');
}
