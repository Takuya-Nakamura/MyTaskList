import 'package:flutter/material.dart';
import 'dart:developer'; //inspect
import '../auth/auth.dart';
import '../components/drawer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String uid = '';
  @override
  void initState() {
    super.initState();
    initUser();
  }

  //一応これでUIDは取得できる。
  void initUser() async {
    final userId = await getUidFromLocal(); //from local
    setState(() {
      uid = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            uid,
            style: TextStyle(color: Colors.white),
          ),
          // toolbarHeight: 40,
          backgroundColor: Colors.blue,
          shadowColor: Colors.white30,
        ),
        body: ListView(
          children: data.map((d) => _menuItem(d)).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/task_new');
          },
          child: Icon(Icons.add),
        ),
        drawer: appbarDrawer(context));
  }

  Widget _menuItem(String title) {
    return Card(
        child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/task_list');
            },
            child: ListTile(
              title: Text(title),
              trailing: Icon(Icons.arrow_right),
            )));
  }
}

// ***********************
// data
// ***********************
const List<String> data = [
  'いつか実現したいこと（全部）',
  '2021年に実現したいこと',
  '2022年に実現したいこと',
];
