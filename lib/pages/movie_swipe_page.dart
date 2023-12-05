import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';

class MovieSwipePage extends StatefulWidget {
  const MovieSwipePage({Key? key}) : super(key: key);

  @override
  State<MovieSwipePage> createState() => _MovieSwipePageState();
}

//02bbcf52d41345c8be5ab2cfc8eb3bec
class _MovieSwipePageState extends State<MovieSwipePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('ReelSync'),
        ),
        body: Column(
          children: [
            const Text("Movies Page"),
            Text("${movieSessionProvider.deviceId}")
          ],
        ),
      ),
    );
  }
}
