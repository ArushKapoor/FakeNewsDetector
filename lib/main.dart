import 'package:fake_news_detector/Screens/NewsScreen.dart';
import 'package:fake_news_detector/Screens/ShowcaseScreen.dart';
import 'package:fake_news_detector/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
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
        appBarTheme: AppBarTheme(
          color: Color(0xff2487ff),
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        ShowcaseScreen.id: (context) => ShowcaseScreen(),
        AppBody.id: (context) => AppBody(),
        NewsScreen.id: (context) => NewsScreen()
      },
    );
  }
}
