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
            const Text("Join Session Page"),
            Text("${movieSessionProvider.deviceId}"), //checking for context
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                child:
                    JoinSessionForm(movieSessionProvider: movieSessionProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Create a Form widget.
class JoinSessionForm extends StatefulWidget {
  final MovieSessionProvider movieSessionProvider;

  const JoinSessionForm({Key? key, required this.movieSessionProvider})
      : super(key: key);

  @override
  JoinSessionFormState createState() {
    return JoinSessionFormState(movieSessionProvider);
  }
}

class JoinSessionFormState extends State<JoinSessionForm> {
  final MovieSessionProvider movieSessionProvider;
  JoinSessionFormState(this.movieSessionProvider);

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

//SNACKBAR  TODO:Add enum for success/error
  tellUser(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              4,
              (index) => buildTextFormField(index),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String sessionCode = controllers
                    .map((controller) => controller.text)
                    .toList()
                    .reduce((value, element) => value + element); //4 digit code
                //build url
                print('Session Code: $sessionCode');
                try {
                  await movieSessionProvider.setMovieNightUrl(
                      SessionType.guest, sessionCode);
                  Navigator.pushNamed(context, '/vote');
                } catch (e) {
                  tellUser("Invalid code");
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(int index) {
    return SizedBox(
      height: 68,
      width: 64,
      child: TextFormField(
        autofocus: index == 0 ? true : false, //only first auto focused
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
        decoration: const InputDecoration(
          fillColor: Colors.white38,
          filled: true,
          border: OutlineInputBorder(),
          errorStyle: TextStyle(
            color: Colors.transparent,
            fontSize: 0,
          ),
        ),
        style: Theme.of(context).textTheme.headline6,
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
