import 'package:flutter/material.dart';
import '../styles/common.dart' as styles;
import 'dart:developer'; //inspect
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth.dart';

class TaskNew extends StatefulWidget {
  // TaskNew({Key key}) : super(key: key);

  @override
  _TaskNewState createState() => _TaskNewState();
}

class _TaskNewState extends State<TaskNew> {
  String uid;
  String title;
  String memo;
  String year = '気が向いたらー';

  @override
  void initState() {
    super.initState();
    initUser();
  }

  void initUser() async {
    final userId = await getUidFromLocal(); //from local
    setState(() {
      uid = userId;
    });
  }

  //*************
  // event handler
  //*************
  void onClickSave() {
    addTask();
  }

  //*************
  // api
  //*************
  // doc一つ取得
  void fetchFirebase() async {
    final DocumentSnapshot snap = await Firestore.instance
        .collection('users')
        .document('3ojqFwDtGSgZLeiT9K6s')
        .get();
    inspect(snap.data['email']);
    inspect(snap.data['name']);
  }

  //collections 複数レコードにアクセス
  void fetchUsers() async {
    final QuerySnapshot qSnap = await Firestore.instance
        .collection('users')
        .orderBy('key')
        .getDocuments();
    final users = qSnap.documents.map((doc) => doc.data);
    inspect(users);
  }

  void addTask() async {
    //任意のIDの場合はsetを使う
    Firestore.instance
        .collection('users')
        .document(uid)
        .collection('tasks')
        .add({
          'title': title,
          'memo': memo,
          'year': year,
          'created': DateTime.now().millisecondsSinceEpoch
        })
        .then((value) => {
              //homeをrouteにして
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', ModalRoute.withName('/home')),
              // Navigator.pop(context),
              //task_listに遷移
              Navigator.pushNamed(context, '/task_edit')
            })
        .catchError((error) => print(error));
  }

  void updateUser() {
    Firestore.instance
        .collection('users')
        .document('test1')
        .updateData({'name': 500})
        .then((value) => print('success'))
        .catchError((error) => print(error));
  }

  void deleteUser() {
    Firestore.instance
        .collection('users')
        .document('test1')
        .delete()
        .then((value) => print('success'))
        .catchError((error) => print(error));
  }

  void addSubCorrections() {
    Firestore.instance
        .collection('users')
        .document('user2')
        .collection('tasks')
        .document('task1')
        .setData({'name': 1, 'title': 2})
        .then((value) => print('success'))
        .catchError((error) => print(error));
  }

  //*************
  // build
  //*************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新規作成'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [titleForm(), memoForm(), selectForm(), saveButton()],
        ));
  }

  //*************
  // Form Item
  //*************

  Widget titleForm() {
    return Padding(
        padding: formPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formLabel('やりたいことを書いてね'),
            TextFormField(
              onChanged: (text) {
                setState(() {
                  title = text;
                });
              },
              decoration: InputDecoration(
                // labelText: 'やりたいことを書いてね',
                enabledBorder: styles.Border.enableFormBorder,
                focusedBorder: styles.Border.focusFormBorder,
              ),
            )
          ],
        ));
  }

  Widget memoForm() {
    return Padding(
        padding: formPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formLabel('細かいことがあったらここにどうぞ♥'),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              minLines: 6,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(),
              onChanged: (text) {
                setState(() {
                  memo = text;
                });
              },
              decoration: InputDecoration(
                // labelText: 'なんか細かいこと書きたかったらどうぞ',
                enabledBorder: styles.Border.enableFormBorder,
                focusedBorder: styles.Border.focusFormBorder,
              ),
            ),
          ],
        ));
  }

  Widget selectForm() {
    return Padding(
        padding: formPadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          formLabel('適当に何年にまでにやりたいか入れる？'),
          DropdownButton<String>(
            value: year,
            onChanged: (newValue) {
              setState(() {
                year = newValue;
              });
            },
            items: menuItems,
          )
        ]));
  }

  Widget saveButton() {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        onClickSave();
      },
      child: Text(
        "作成",
      ),
    ));
  }

  //*************
  // Parts
  //*************
  Widget formLabel(String text) {
    return Padding(
        padding: EdgeInsets.only(top: 0, right: 0, bottom: 5, left: 0),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ));
  }
}

// ***********************
// data
// ***********************
final List<String> data = [
  '新規追加する',
];

final List<String> years = [
  '2000',
  '2001',
  '2002',
  '2003',
  '2004',
  '2005',
  '2006',
  '2007',
  '2008',
  '2009',
  '2010',
  '2011',
  '2012',
  '2013',
  '2014',
  '2015',
  '2016',
  '2017',
  '2018',
  '気が向いたらー'
];

var menuItems = years.map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  );
}).toList();

final formPadding = EdgeInsets.only(top: 20, right: 20, bottom: 40, left: 20);
