import 'package:checklist/pages/create_task_page.dart';
import 'package:checklist/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        'create_task': (_) => CreateTaskPage(),
      },
    );
  }
}
