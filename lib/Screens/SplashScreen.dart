import 'package:fake_news_detector/Screens/ShowcaseScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isInitialized = false;
  void inititalizeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      final _auth = FirebaseAuth.instance;
      await _auth.signInAnonymously();
      isInitialized = true;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    inititalizeFlutterFire();
    Future.delayed(Duration(seconds: 3), () {
      if (isInitialized) Navigator.pushNamed(context, ShowcaseScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(25.0)),
              child: Center(
                child: Text(
                  'Fake',
                  style: GoogleFonts.mcLaren(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Test kiya kya!',
              style: GoogleFonts.pacifico(fontSize: 35, color: Colors.black54),
            )
          ],
        ),
      ),
    );
  }
}
