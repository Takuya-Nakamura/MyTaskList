import 'package:flutter/material.dart';
import '../styles/common.dart' as styles;
import 'dart:developer'; //inspect
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../components/aniamted_icon_button.dart';
import '../components/heart_rate.dart';
import '../components/icon_switch.dart';
import '../components/icon_check.dart';

class TaskEdit extends StatefulWidget {
  //params
  final String uid;
  final String taskId;

  TaskEdit({Key key, this.uid, this.taskId}) : super(key: key);

  @override
  _TaskEditState createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  String key;
  String uid;
  String title;
  String memo;
  String year;
  bool isSwitched = false;
  DateTime _date = new DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      uid = widget.uid;
    });
    fetchTask();
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
  void fetchTask() async {
    final DocumentSnapshot snap = await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .collection('tasks')
        .document(widget.taskId)
        .get();

    setState(() {
      title = snap.data['title'];
      memo = snap.data['memo'];
      year = snap.data['year'];
    });
  }

  void addTask() async {
    //自動IDの場合はadd
    // Firestore.instance.collection('users')
    //     .add({'name': 'name1', 'memo': 'memo2'})
    //     .then((value) => print('success'))
    //     .catchError((error) => print(error));

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
              Navigator.pushNamed(context, '/task_list')
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
          title: Text('編集'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // titleForm(title),
            Padding(
                padding: formPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // formLabel('やりたいことを書いてね♥'),
                    TextFormField(
                      initialValue: title,
                      onChanged: (text) {
                        setState(() {
                          title = text;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'タイトル',
                        enabledBorder: styles.Border.enableFormBorder,
                        focusedBorder: styles.Border.focusFormBorder,
                      ),
                    )
                  ],
                )),

            // animetateIcon(),
            memoForm(), selectForm(),
            wantRateForm(), categoryForm(), statusForm(), saveButton(),
          ],
        ))));
  }

  //*************
  // Form Item
  //*************

  Widget titleForm(String value) {
    return Padding(
        padding: formPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            formLabel('やりたいことを書いてね'),
            TextFormField(
              initialValue: title,
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
            // formLabel('細かいメモがあったらどうぞ♥'),
            TextFormField(
              initialValue: memo,
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
                labelText: 'メモ',
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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          formLabel('今年の目標にする？'),
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

  // TODO 選択時にアニメーションにしたい
  // ライブラリの利用はやめようかな
  // 未選択は小さくなって選択済みはプルルンみたいな...

  Widget wantRateForm() {
    return Padding(
        padding: formPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          formLabel('どれぐらい実現したい？'),
          HeartRate(),
        ]));
  }

  Widget statusForm() {
    initializeDateFormatting('ja');
    var format = new DateFormat.yMMMd('ja');
    return Padding(
        padding: formPadding,
        child: Container(
            height: 85,
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  formLabel('進捗状況'),
                  IconCheck(),
                ]))));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    if (picked != null) setState(() => _date = picked);
  }

  Widget categoryForm() {
    return Padding(
        padding: formPadding,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [formLabel('たのしみ？ つらい?'), IconSwitch()]));
  }

  Widget saveButton() {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        onClickSave();
      },
      child: Text(
        "保存",
      ),
    ));
  }

  Widget animetateIcon() {
    return Center(
      child: AniamtedIconButton(),
    );
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
  '気が向いたらー',
  'そのうち',
];

var menuItems = years.map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  );
}).toList();

final formPadding = EdgeInsets.only(top: 20, right: 20, bottom: 10, left: 20);
