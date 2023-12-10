import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  JoinSessionForm(movieSessionProvider: movieSessionProvider),
            ),
          ],
        ),
      ),
    );
  }
}

// Code input form
class JoinSessionForm extends StatefulWidget {
  final MovieSessionProvider movieSessionProvider;

  const JoinSessionForm({Key? key, required this.movieSessionProvider})
      : super(key: key);

  @override
  JoinSessionFormState createState() {
    return JoinSessionFormState(movieSessionProvider);
  }
}

class JoinSessionFormState extends State<JoinSessionForm>
    with TickerProviderStateMixin {
  final MovieSessionProvider movieSessionProvider;
  late AnimationController _animationController; //btn gradient
  late Animation<Alignment> _bottomAlignmentAnimation; //btn gradient
  late AnimationController iconController;
  late Animation<double> iconAnimation;
  bool playIconAnimation = false;

  JoinSessionFormState(this.movieSessionProvider);

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  // Button Gradient animations
  @override
  void initState() {
    super.initState();
    iconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(iconController);

//Btn gradient
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.centerRight,
            end: Alignment.center,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.center,
            end: Alignment.centerRight,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.centerRight,
            end: Alignment.center,
          ),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
            begin: Alignment.center,
            end: Alignment.centerRight,
          ),
          weight: 1,
        ),
      ],
    ).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose(); //ANIMATION CONTROLLER rename
    iconController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void toggleIconAnimation() {
    setState(() {
      playIconAnimation = !playIconAnimation;
      if (playIconAnimation) {
        iconController.forward(); //play animation
        iconController.repeat(reverse: false); //no reverse
        Future.delayed(const Duration(milliseconds: 700), () {
          iconController.stop(); //stop after 1s
          playIconAnimation = !playIconAnimation; //reset state to false
        });
      } else {
        return;
      }
    });
  }

//SNACKBAR  TODO:Add enum for success/error
  tellUser(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).viewPadding;
    double height = size.height;

    return Form(
      key: _formKey,
      child: Container(
        height: (height - padding.top - kToolbarHeight - padding.bottom) - 80,
        // decoration: BoxDecoration(color: Colors.red),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  4,
                  (index) => buildTextFormField(index),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                toggleIconAnimation();
                if (_formKey.currentState!.validate()) {
                  String sessionCode = controllers
                      .map((controller) => controller.text)
                      .toList()
                      .reduce((value, element) => value + element);
                  try {
                    await movieSessionProvider.setMovieNightUrl(
                        SessionType.guest, sessionCode, null, null);
                    //play the icon animation
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pushNamed(context, '/vote');
                    });
                  } catch (e) {
                    tellUser("Invalid code");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return Container(
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
                    child: Center(child: buttonText()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(int index) {
    return Container(
      height: 68,
      width: 55,
      child: TextFormField(
        autofocus: index == 0 ? true : false,
        style: TextStyle(color: Theme.of(context).colorScheme.onTertiary),
        controller: controllers[index],
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a valid code";
          }
          return null;
        },
        onSaved: (value) {},
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.onSurface,
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          errorStyle: const TextStyle(
            color: Colors.transparent,
            fontSize: 0,
          ),
        ),
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }

//loads Join or play animation
  Widget buttonText() {
    if (playIconAnimation) {
      return AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: (playIconAnimation ? 1 : 0),
        child: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          color: Theme.of(context).colorScheme.background,
          progress: iconAnimation,
          size: 60,
        ),
      );
    } else {
      return Text('Join');
    }
  }
}
