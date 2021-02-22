import 'package:flutter/material.dart';
import 'package:idkit_activityindicator/idkit_activityindicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page(),
    );
  }
}

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("活动指示器测试"),
      ),
      body: Center(
        child: Container(
          child: IDKitActivityIndicator(
            radius: 30,
            color: Colors.grey,
            count: 10,
          ),
        ),
      ),
    );
  }
}
