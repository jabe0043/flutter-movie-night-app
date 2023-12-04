import 'package:flutter/material.dart';
import 'package:movie_night_app/models/movie_session_provider.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
          title: const Text('ReelSync'),
        ),
        //BODY
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/host');
                },
                child: const Text('Host a Session'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/join');
                },
                child: const Text('Join a Session'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/movies');
                },
                child: const Text('movies test'),
              ),
              Center(
                child: Text(
                  "Device ID: ${movieSessionProvider.deviceId}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
