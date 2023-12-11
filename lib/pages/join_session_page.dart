import 'package:flutter/material.dart';
import 'package:movie_night_app/provider/movie_session_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:movie_night_app/custom_widgets/gradient_btn.dart';

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
            foregroundColor: Theme.of(context).colorScheme.onBackground,
            title: const Text('ReelSync'),
            backgroundColor: Theme.of(context).colorScheme.background),
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

  JoinSessionFormState(this.movieSessionProvider);

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

//snackbar alert
  tellUser(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style:
                TextStyle(color: Theme.of(context).colorScheme.onBackground)),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

//handle button press and navigate
  handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      String sessionCode = controllers
          .map((controller) => controller.text)
          .toList()
          .reduce((value, element) => value + element);
      try {
        await movieSessionProvider.setMovieNightUrl(
            SessionType.guest, sessionCode, null, null);
        Navigator.pushNamed(context, '/vote');
      } catch (e) {
        tellUser("Invalid code");
      }
    } else {
      tellUser("Missing digits");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).viewPadding;
    double height = size.height;

    return Form(
      key: _formKey,
      child: SizedBox(
        height: (height - padding.top - kToolbarHeight - padding.bottom) - 80,
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
                    Text("Enter your 4 digit code",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary)),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        4,
                        (index) => buildTextFormField(index),
                      ),
                    ),
                    const Spacer(),
                  ],
                )),
            GradientButton(
              onPressed: () async => await handleSubmit(),
              btnText: "Join",
              btnTextColor: Theme.of(context).colorScheme.onBackground,
              gradientColors: [
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.onTertiary,
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(int index) {
    return Container(
      height: 65,
      width: 55,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        autofocus: true,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onTertiary,
          fontSize: 30,
        ),
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
}
