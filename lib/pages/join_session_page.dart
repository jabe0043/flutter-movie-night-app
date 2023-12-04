import 'package:flutter/material.dart';
import 'package:movie_night_app/models/movie_session_provider.dart';
import 'package:provider/provider.dart';

class JoinSessionPage extends StatefulWidget {
  const JoinSessionPage({Key? key}) : super(key: key);

  @override
  State<JoinSessionPage> createState() => _JoinSessionPageState();
}

class _JoinSessionPageState extends State<JoinSessionPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('ReelSync'),
        ),
        body: Column(
          children: [
            const Text("Join Session Page"),
            Text("${movieSessionProvider.deviceId}") //checking for context
          ],
        ),
      ),
    );
  }
}
