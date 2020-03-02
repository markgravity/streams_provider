import 'package:example/sign_in_provider.dart';
import 'package:example/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:streams_provider/streams_provider.dart';


void main() {
  runApp(App());
}
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: StreamsProvider<SignInProvider>(
        create: (_) => SignInProvider(),
        child: SignInScreen(),
      ),
    );
  }
}



