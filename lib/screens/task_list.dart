import 'package:flutter/material.dart';
import 'dart:developer'; //inspect
import '../auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // ***********************
  // state
  // ***********************

  String uid = '';
  List<DocumentSnapshot> tasks = [];

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
    fetchUserTasks(uid);
  }

  // ***********************
  // api
  // ***********************
  //collections 複数レコードにアクセス
  void fetchUserTasks(String uid) async {
    final QuerySnapshot qSnap = await Firestore.instance
        .collection('users')
        .document(uid)
        .collection('tasks')
        .orderBy('created')
        .getDocuments();

    // qSnap.documents.forEach((element) => {print(element.documentID)});

    final _tasks = qSnap.documents;
    print("users");
    inspect(_tasks);
    setState(() {
      tasks = _tasks;
    });
  }

  // ***********************
  // build
  // ***********************

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('やってみたいことー'),
      ),
      body: ListView(
        // children: data.map((d) => _menuItem(d, context)).toList(),
        children: tasks.map((d) => _menuItem(d, context)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/task_new');
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _menuItem(DocumentSnapshot task, context) {
    return Card(
        child: InkWell(
            onTap: () {
              // Navigator.pushNamed(context, '/task_new');
              Navigator.pushNamed(context, '/task_edit', arguments: {
                'uid': uid,
                'taskId': task.documentID,
              });
            },
            child: ListTile(
              title: Text(task.data['title']), //keyを取得する
              trailing: Icon(Icons.arrow_right),
            )));
  }
}

// ***********************
// eventhandler
// ***********************
// void _onPressAddButton(BuildContext context) {
//   // Navigator.pushNamed(context, '/task_list');
// }

// ***********************
// action
// ***********************

// ***********************
// data
// ***********************
const List<String> data = [
  '新規追加する',
  'しゃぶしゃぶ食べ放題',
  '八郎潟で釣りをする！',
  '1週間釣り三昧をする！',
];
