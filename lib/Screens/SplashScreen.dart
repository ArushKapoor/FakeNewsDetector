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
  AnimationController _animateController;

  bool iamhere = false;
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
    _animateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animateController.forward();
    _animateController.addListener(() {
      setState(() {});
    });
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      upperBound: 1,
    );

    _animationController.reverse(from: 1);

    _animationController.addListener(() {
      setState(() {
        if (_animationController.value <= 0.154) {
          _animationController.stop();

          iamhere = true;
        }
      });
    });
    Future.delayed(
      Duration(seconds: 4),
      () {
        if (isInitialized) {
          Navigator.pushReplacementNamed(context, ShowcaseScreen.id);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animateController.dispose();
    _animateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    //double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Center(
            child: Container(
              height: 1000 * (_animateController.value),
              width: 1000 * (_animateController.value),
              // color: Colors.orange,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius:
                    BorderRadius.circular((1 - _animateController.value) * 600),
              ),

              child: Column(
                children: [
                  if (iamhere)
                    SizedBox(
                      height: _height * 0.65,
                    ),
                  if (iamhere)
                    Text(
                      'Check Kiya Kya',
                      style: GoogleFonts.pacifico(
                        color: Colors.brown,
                        fontSize: 30,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              height: 1000 * _animationController.value,
              width: 1000 * _animationController.value,
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(
                  600 * (1 - _animationController.value),
                ),
              ),
              child: Center(
                child: Opacity(
                  opacity: 1,
                  child: Container(
                    height: 160,
                    width: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/Images/logo.png',
                        ),
                      ),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
