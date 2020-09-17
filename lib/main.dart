import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Screens/MainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fake News Detector'),
          backgroundColor: Colors.pink,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Center(
                child: AppBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
