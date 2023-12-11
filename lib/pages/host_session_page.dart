import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/custom_widgets/gradient_btn.dart';

class HostSessionPage extends StatefulWidget {
  const HostSessionPage({Key? key}) : super(key: key);

  @override
  State<HostSessionPage> createState() => _HostSessionPageState();
}

class _HostSessionPageState extends State<HostSessionPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).viewPadding;
    double height = size.height;
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.onBackground,
            title: const Text('ReelSync'),
            backgroundColor: Theme.of(context).colorScheme.background),
        body: Container(
          padding: const EdgeInsets.all(16),
          height: (height - padding.top - kToolbarHeight - padding.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      "Share this code with your friend",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => displayCode(
                            movieSessionProvider.hostSessionInfo!.code, index),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              GradientButton(
                onPressed: () => Navigator.pushNamed(context, '/vote'),
                btnText: "Start",
                btnTextColor: Theme.of(context).colorScheme.onBackground,
                gradientColors: [
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.error,
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displayCode(String code, index) {
    return Container(
      height: 68,
      width: 55,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          code.substring(index, index + 1),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 30),
        ),
      ),
    );
  }
}
