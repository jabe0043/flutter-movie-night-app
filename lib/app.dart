import 'package:flutter/material.dart';
import 'package:movie_night_app/pages/welcome_page.dart';
import 'package:movie_night_app/pages/host_session_page.dart';
import 'package:movie_night_app/pages/join_session_page.dart';
import 'package:movie_night_app/pages/vote_page.dart';
import 'package:movie_night_app/theme/color_theme.dart';
import 'package:movie_night_app/theme/text_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //any state vars?

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'PlusJakartaSans',
        colorScheme: darkColorScheme,
        textTheme: textTheme,
      ),
      initialRoute: "/welcome",
      builder: (context, child) {
        return Column(
          children: [
            Expanded(child: child ?? Container()),
          ],
        );
      },
      routes: <String, WidgetBuilder>{
        "/welcome": (BuildContext context) => const WelcomePage(),
        '/host': (BuildContext context) => const HostSessionPage(),
        '/join': (BuildContext context) => const JoinSessionPage(),
        '/vote': (BuildContext context) => const VotePage(),
      },
    );
  }
}
