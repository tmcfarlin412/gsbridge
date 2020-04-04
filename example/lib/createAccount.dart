import 'package:flutter/material.dart';
import 'package:gsbridge/gsbridge.dart';
import 'package:flutter/services.dart';

// Define a corresponding State class.
// This class holds the data related to the Form.
class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";
  bool isRegistering = false;

  Future<void> registration() async {
    if (!isRegistering) {
      setState(() {
        isRegistering = true;
      });

      try {
        Map<String, dynamic> result = await Gsbridge.registration("", "en",
            usernameController.text, passwordController.text);
        if (result["status"] == Gsbridge.STATUS_SUCCESS) {
          Navigator.pop(context, RegistrationPage.RESULT_SUCCESS);
        } else if (result["status"] == Gsbridge.STATUS_FAILURE) {
          setState(() {
            errorMessage = "Registration failed, please try again!";
            isRegistering = false;
          });
        }
      } on PlatformException {
        setState(() {
          errorMessage = "Registration failed, please try again";
          isRegistering = false;
        });
      }
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
                        Text("Create an account"),
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
                            Text(isRegistering ? "Registering..." : "Register"),
                            onPressed: () {
                              registration();
                            }
                        ),
                        Text(errorMessage)
                      ],
                    )))));
  }
}

class RegistrationPage extends StatefulWidget {
  static const RESULT_SUCCESS = "RESULT_SUCCESS";

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}
