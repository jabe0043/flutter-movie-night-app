import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:movie_night_app/data/http_helper.dart';
import 'package:movie_night_app/data/models/session_api_model.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

//host: {data: {message: new session created., code: 9902, session_id: 0e40349e-3aab-4183-844a-63bc2a640bd5}}

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
              //HOSTING A SESSION
              ElevatedButton(
                onPressed: () async {
                  //build and fetch
                  try {
                    await movieSessionProvider.setMovieNightUrl(
                        SessionType.host, null, null, null);
                    Navigator.pushNamed(context, '/host');
                  } catch (e) {
                    print("error");
                  }
                },
                child: const Text('Host a Session'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/join');
                },
                child: const Text('Join a Session'),
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
