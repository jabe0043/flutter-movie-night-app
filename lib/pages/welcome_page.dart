import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

//Button Gradient animations
    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.centerRight, end: Alignment.center),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.center, end: Alignment.centerRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.centerRight, end: Alignment.center),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.center, end: Alignment.centerRight),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
            title: const Text('ReelSync'),
            titleTextStyle:
                TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            backgroundColor: Theme.of(context).colorScheme.background),
        //BODY
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await movieSessionProvider.setMovieNightUrl(
                          SessionType.host, null, null, null);
                    } catch (e) {
                      print("error");
                    }
                    Navigator.pushNamed(context, '/host');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.onPrimary,
                              Theme.of(context).colorScheme.error,
                            ],
                            end: _bottomAlignmentAnimation.value,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text('Host a Session'),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 50),

                //Joining a session
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/join');
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0)),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.tertiary,
                              Theme.of(context).colorScheme.onTertiary,
                            ],
                            end: _bottomAlignmentAnimation.value,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Center(
                          child: Text('Join a Session'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
