import 'package:fake_news_detector/Screens/NewsScreen.dart';
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
      initialRoute: AppBody.id,
      routes: {
        AppBody.id: (context) => AppBody(),
        NewsScreen.id: (context) => NewsScreen()
      },
    );
  }
}
