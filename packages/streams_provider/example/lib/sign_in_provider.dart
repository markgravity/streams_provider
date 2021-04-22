import 'package:flutter/cupertino.dart';
import 'package:streams_provider/streams_provider.dart';

class SignInProvider implements StreamsProvidable {
  SignInProvider() {
    username = usernameTextController.textStream();
  }

  // Username
  final usernameTextController = TextEditingController();
  MutableValueStream<String> username;
  Stream<String> get usernameError => username.map((o) => validateUsername(o));

  // Password
  final password = MutableValueStream<String>("");
  Stream<String> get passwordError => password.map((o) => validatePassword(o));

  // No error on any fields
  Stream<bool> get isAllValid =>
    [usernameError, passwordError].combineLatest().mapEvery((o) => o == null);

  // Methods
  String validateUsername(String username) {
    try {
      validateString("Username", username);
      validateMaxLength("Username", username, 10);
    } on String catch (e) {
      return e;
    }

    return null;
  }

  String validatePassword(String username) {
    try {
      validateString("Password", username);
      validateMaxLength("Password", username, 6);
    } on String catch (e) {
      return e;
    }

    return null;
  }

  // Validate helpers
  void validateString(String field, String value) {
    if (value == null || value.length == 0) throw "$field is required";
  }

  void validateMaxLength(String field, String value, int max) {
    if (value.length > max) throw "The maximum length of $field is $max characters";
  }

  Future<void> dispose() {
    return StreamsDisposeBag([username, password]).dispose();
  }
}
