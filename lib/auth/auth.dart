import 'package:flutter/material.dart';
import 'dart:developer'; //inspect
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* form text */
FirebaseUser firebaseUser;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> isSignIn() async {
  firebaseUser = await _auth.currentUser();
  return firebaseUser != null;
}

Future<bool> skipSplashPage(context) async {
  firebaseUser = await _auth.currentUser();
  if (firebaseUser != null) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/home', ModalRoute.withName('/home'));
  }
}

// ***********************
// api
// ***********************

Future<String> getUidFromApi() async {
  final user = await _auth.currentUser();
  return user.uid;
}

Future<void> signInWithGoogle(BuildContext context) async {
  print('signInWithGoogle');
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  // //ログイン実行
  await FirebaseAuth.instance.signInWithCredential(credential);
  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  saveUidToLocal(user.uid);
  Navigator.pushNamedAndRemoveUntil(
      context, '/home', ModalRoute.withName('/home'));
}

void anonymousSingIn(BuildContext context) async {
  await _auth.signInAnonymously();
  final user = await _auth.currentUser();
  saveUidToLocal(user.uid);
  Navigator.pushNamedAndRemoveUntil(
      context, '/home', ModalRoute.withName('/home'));
}

void signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  saveUidToLocal('');
  //stackを全部消す
  Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
}

// ***********************
// shared_preferences
// ***********************

saveUidToLocal(String uid) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString("uid", uid);
}

getUidFromLocal() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  print(pref);
  return pref.get("uid");
}
