import 'package:flutter/material.dart';
import 'package:movie_night_app/theme/text_theme.dart';
import 'package:provider/provider.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:movie_night_app/custom_widgets/welcome_hero.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSessionProvider>(
      builder: (context, movieSessionProvider, child) => Scaffold(
        appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.onBackground,
            title: const Text('ReelSync'),
            backgroundColor: Theme.of(context).colorScheme.background),
        //BODY
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(0, 80),
                    child: const HeroBanner(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 8, left: 16, right: 16, bottom: 0),
                    child: Text("Find your movie mate",
                        style: textTheme.displaySmall),
                  ),
                ],
              ),

              const SizedBox(height: 120),
              //Host Session
              AnimatedGradientBtn(
                btnTextTitle: "Host a Vote Session",
                btnTextSubtitle: "Share your code with friends",
                btnIcon: Icons.sensors,
                primaryColor: Theme.of(context).colorScheme.onPrimary,
                secondaryColor: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  try {
                    await movieSessionProvider.setMovieNightUrl(
                        SessionType.host, null, null, null);
                  } catch (e) {
                    return;
                  }
                  Navigator.pushNamed(context, '/host');
                },
              ),
              const SizedBox(height: 24),
              //Join Session
              AnimatedGradientBtn(
                btnTextTitle: "Join a Vote Session",
                btnTextSubtitle: "Enter your code and start voting",
                btnIcon: Icons.connect_without_contact,
                primaryColor: Theme.of(context).colorScheme.onTertiary,
                secondaryColor: Theme.of(context).colorScheme.tertiary,
                onPressed: () {
                  Navigator.pushNamed(context, '/join');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Animated Gradient button Widget
class AnimatedGradientBtn extends StatefulWidget {
  final VoidCallback onPressed;
  final Color primaryColor;
  final Color secondaryColor;
  final String btnTextTitle;
  final String btnTextSubtitle;
  final IconData btnIcon;

  const AnimatedGradientBtn({
    Key? key,
    required this.onPressed,
    required this.primaryColor,
    required this.secondaryColor,
    required this.btnTextTitle,
    required this.btnTextSubtitle,
    required this.btnIcon,
  }) : super(key: key);

  @override
  AnimatedGradientBtnState createState() => AnimatedGradientBtnState();
}

class AnimatedGradientBtnState extends State<AnimatedGradientBtn>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.primaryColor, widget.secondaryColor],
                  end: _bottomAlignmentAnimation.value,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      widget.btnIcon,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 40.0,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.btnTextTitle,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.btnTextSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
