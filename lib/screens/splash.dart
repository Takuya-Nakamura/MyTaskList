import 'package:flutter/material.dart';
import 'dart:developer'; //inspect
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../auth/auth.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // ***********************
  // event
  // ***********************
  @override
  void initState() {
    super.initState();
  }

  // ***********************
  // build
  // ***********************
  @override
  Widget build(BuildContext context) {
    skipSplashPage(context);

    return Scaffold(
        // appBar: AppBar(),
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  signInWithGoogle(context);
                },
                child: Text(
                  "Googleでログイン",
                ),
              )),
          SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.grey),
                onPressed: () {
                  anonymousSingIn(context);
                },
                child: Text(
                  "ログインしないで使う",
                ),
              )),
        ],
      ),
    ));
  }
}
