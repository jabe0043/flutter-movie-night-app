import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:movie_night_app/app.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => MovieSessionProvider()..userDeviceId(),
    child: const MyApp(),
  ));
}
