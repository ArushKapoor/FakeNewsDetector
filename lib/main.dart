import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class AppBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            border: Border.all(
              color: Colors.black,
              width: 0.4,
            ),
          ),
          padding: EdgeInsets.all(8.0),
          width: _width * 0.7,
          height: _height * 0.5,
          child: Text(
            'Enter text...',
            style: TextStyle(
              fontSize: _height * 0.03,
            ),
          ),
        ),
        SizedBox(
          height: _height * 0.1,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          width: _width * 0.55,
          height: _height * 0.09,
          child: Center(
            child: Text(
              'VERIFY',
              style: TextStyle(fontSize: _height * 0.03, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
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
          child: Center(child: AppBody()),
        ),
      ),
    );
  }
}
