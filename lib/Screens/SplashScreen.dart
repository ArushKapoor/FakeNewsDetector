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

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isInitialized = false;
  AnimationController _animationController;
  Animation _animation;
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
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
      upperBound: 1,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle);
    _animationController.reverse(from: 1);
    _animationController.addListener(() {
      setState(() {});
    });
    Future.delayed(Duration(seconds: 4), () {
      if (isInitialized) {
        Navigator.pushReplacementNamed(context, ShowcaseScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/Images/logo.png',
                    ),
                  ),
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(75),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: _animation.value * _height,
              width: _animation.value * _width,
              color: Colors.brown,
              decoration: BoxDecoration(),
            ),
          ),
        ],
      ),
    );
  }
}
