import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
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
            Text("device id: ${movieSessionProvider.deviceId}"),
            Text(
                "host session id: ${movieSessionProvider.hostSessionInfo!.sessionId}"),
            Text(
              "host session code: ${movieSessionProvider.hostSessionInfo!.code}",
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/vote');
                },
                child: child)
          ],
        ),
      ),
    );
  }
}
