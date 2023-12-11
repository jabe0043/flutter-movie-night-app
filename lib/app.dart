import 'package:flutter/material.dart';
import 'package:movie_night_app/pages/welcome_page.dart';
import 'package:movie_night_app/pages/host_session_page.dart';
import 'package:movie_night_app/pages/join_session_page.dart';
import 'package:movie_night_app/pages/vote_page.dart';

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
        scaffoldBackgroundColor: const Color(0xFF121212), //1
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xFF1d1d1d), //2
          onPrimary: const Color(0xFFFF8C00), //orange 1
          secondary: const Color(0xFF252525), //4
          onSecondary: Colors.black,
          tertiary: const Color(0xFF8BC34A),
          // onTertiary: const Color(0xFF4CAF50),
          onTertiary: const Color(0xFF43A047),
          error: Colors.red,
          onError: Colors.red.shade900,
          background: const Color(0xFF121212), //2
          onBackground: const Color(0xFFFFFFFF),
          surface: const Color(0xFF1d1d1d),
          onSurface: const Color(0xFF222222),
        ),
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
