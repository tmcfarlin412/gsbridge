import 'package:flutter/material.dart';
import 'package:gsbridge/gsbridge.dart';
import 'package:flutter/services.dart';
import 'package:gsbridge_example/createAccount.dart';
import 'package:gsbridge_example/newGame.dart';

// Define a corresponding State class.
// This class holds the data related to the Form.
class _LoginPageState extends State<LoginPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoggingIn = false;
  bool isLoggedIn = false;
  String loginErrorMessage = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!isLoggingIn) {
      setState(() {
        isLoggingIn = true;
      });

      try {
        Map<String, dynamic> result = await Gsbridge.authenticate(
            usernameController.text, passwordController.text);
        if (result["status"] == Gsbridge.STATUS_SUCCESS) {
          isLoggingIn = false;
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewGamePage()));
        } else if (result["status"] == Gsbridge.STATUS_FAILURE) {
          setState(() {
            loginErrorMessage = "Login failed, please try again!";
            isLoggingIn = false;
          });
        }
      } on PlatformException {
        setState(() {
          loginErrorMessage = "Login failed, please try again";
          isLoggingIn = false;
        });
      }
    }
  }

  Future<void> pushRegistrationPage() async {
    if (!isLoggingIn) {
      await Navigator.push(context,
          MaterialPageRoute(builder: (context) => RegistrationPage()))
          .then((result) {
        if (result == RegistrationPage.RESULT_SUCCESS) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewGamePage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            return value.isEmpty
                                ? 'Please enter your username'
                                : null;
                          },
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                        ),
                        TextFormField(
                          validator: (value) {
                            return value.isEmpty
                                ? 'Please enter your password'
                                : null;
                          },
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                        ),
                        RaisedButton(
                            child:
                            Text(isLoggingIn ? "Logging in..." : "Login"),
                            onPressed: () {login();}
                        ),
                        FlatButton(
                            child: Text("Register new account"),
                            onPressed: () {pushRegistrationPage();}
                        ),
                        Text(loginErrorMessage)
                      ],
                    )))));
  }
}

class LoginPage extends StatefulWidget {
  static const RESULT_SUCCESS = "RESULT_SUCCESS";

  @override
  _LoginPageState createState() => _LoginPageState();
}
