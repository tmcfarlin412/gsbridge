import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsbridge_example/login.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      runAsyncTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Text("Loading...")
        )
    );
  }

  void runAsyncTasks() async {

    // None right now, push replacement immediately
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => LoginPage()));
  }
}