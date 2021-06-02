import 'package:flutter/material.dart';
import '../auth/auth.dart';

Widget appbarDrawer(BuildContext context) {
  return (Drawer(
      child: ListView(
    children: [
      DrawerHeader(
        child: Text('Drawer Header'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
      ListTile(
        title: Text("ログアウト"),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          signOut(context);
        },
      ),
    ],
  )));
}
