import 'package:flutter/material.dart';
import 'package:gsbridge/gsbridge.dart';
import 'package:flutter/services.dart';

// Define a corresponding State class.
// This class holds the data related to the Form.
class _NewGamePageState extends State<NewGamePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("New game");
  }
}

class NewGamePage extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  static const RESULT_SUCCESS = "RESULT_SUCCESS";

  @override
  _NewGamePageState createState() => _NewGamePageState();
}
