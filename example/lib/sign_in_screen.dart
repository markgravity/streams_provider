import 'package:example/sign_in_provider.dart';
import 'package:flutter/material.dart';
import 'package:stream_provider/stream_provider.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _provider = StreamProvider.of<SignInProvider>(context);
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Username",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4,
              ),
              TextField(
                onChanged: (text) => _provider.username.value = text,
              ),
              SizedBox(
                height: 4,
              ),
              StreamSelector<SignInProvider, String>(
                selector: (_, provider) {
                  return provider.usernameError;
                },
                builder: (_, error, __) => error != null
                    ? Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 4,
              ),
              TextField(
                onChanged: (text) => _provider.password.value = text,
              ),
              SizedBox(
                height: 4,
              ),
              StreamSelector<SignInProvider, String>(
                selector: (_, provider) => provider.passwordError,
                builder: (_, error, __) => error != null
                    ? Text(
                        error,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
              ),
              SizedBox(
                height: 20,
              ),
              StreamSelector<SignInProvider, bool>(
                selector: (_, provider) => provider.isAllValid,
                builder: (_, bool, __) => bool
                    ? FlatButton(
                        onPressed: () {},
                        child: Center(
                          child: Text("Login"),
                        ),
                      )
                    : Text(
                        "*Please fillout all fields.".toUpperCase(),
                        style: TextStyle(color: Colors.deepOrange),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
