import 'package:flutter/material.dart';
import 'package:movie_night_app/models/movie_session_provider.dart';
import 'package:provider/provider.dart';

class MovieSwipePage extends StatefulWidget {
  const MovieSwipePage({Key? key}) : super(key: key);

  @override
  State<MovieSwipePage> createState() => _MovieSwipePageState();
}

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


// class MovieSwipePage extends StatefulWidget {
//   const MovieSwipePage({Key? key, required this.nav, required this.page})
//       : super(key: key);

//   final Function nav;
//   final int page;

//   @override
//   State<MovieSwipePage> createState() => _MovieSwipePageState();
// }

// class _MovieSwipePageState extends State<MovieSwipePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MovieSessionProvider>(
//       builder: (context, movieSessionProvider, child) => Scaffold(
//         appBar: AppBar(
//           title: const Text('ReelSync'),
//         ),
//         body: const Center(
//           child: Text("Swipe Movie Page"),
//         ),
//       ),
//     );
//   }
// }
