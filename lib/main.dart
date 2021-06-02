import 'package:flutter/material.dart';
import './screens/splash.dart';
import './screens/home.dart';
import './screens/task_list.dart';
import './screens/task_new.dart';
import './screens/task_edit.dart';

import './styles/common.dart' as styles;

import './auth/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTaskList',
      // theme: styles.Thema.normal,
      theme: ThemeData(
        // フォントファミリー名を指定します
        // fontFamily: "KosugiMaru",
        // fontFamily: "Potta_One",
        fontFamily: 'KosugiMaru',
      ),
      initialRoute: '/',
      // modalを使わない場合は以下でOK
      // routes: {
      //   '/': (context) => MyHomePage(title: 'Flutter Demo Home Page1'),
      //   '/task_list': (context) => TaskList(),
      //   '/task_new': (context) => TaskNew(),
      // },
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Splash());
      case '/home':
        return MaterialPageRoute(
            builder: (_) => MyHomePage(title: 'Flutter Demo Home Page1'));
      case '/task_list':
        return MaterialPageRoute(
          builder: (_) => TaskList(),
        );
      case '/task_new':
        return MaterialPageRoute(
          builder: (_) => TaskNew(),
          //named toutesでmodalを使うためには、onGenereteでやるしかなさそう
          fullscreenDialog: true,
        );
      case '/task_edit':
        return MaterialPageRoute(
          builder: (_) => TaskEdit(uid: args['uid'], taskId: args['taskId']),
        );
    }
  }
}
