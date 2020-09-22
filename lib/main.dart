import 'package:fake_news_detector/Screens/NewsScreen.dart';
import 'package:fake_news_detector/Screens/ShowcaseScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Screens/MainScreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: ShowcaseScreen.id,
      routes: {
        ShowcaseScreen.id: (context) => ShowcaseScreen(),
        AppBody.id: (context) => AppBody(),
        NewsScreen.id: (context) => NewsScreen()
      },
    );
  }
}
