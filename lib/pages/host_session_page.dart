import 'package:flutter/material.dart';
import 'package:movie_night_app/models/movie_session_provider.dart';
import 'package:provider/provider.dart';

class HostSessionPage extends StatefulWidget {
  const HostSessionPage({Key? key}) : super(key: key);

  @override
  State<HostSessionPage> createState() => _HostSessionPageState();
}

class _HostSessionPageState extends State<HostSessionPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('ReelSync'),
        ),
        body: Column(
          children: [
            const Text("Host Session Page"),
            Text("${movieSessionProvider.deviceId}")
          ],
        ),
      ),
    );
  }
}
