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
  AssetImage logoImage;
  bool iamhere = false;
  void inititalizeFlutterFire() async {
    try {
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
    logoImage = AssetImage('assets/Images/logo3.png');
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
  void didChangeDependencies() {
    precacheImage(logoImage, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _animateController.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    //double _width = MediaQuery.of(context).size.width;
    // print('${(1 - _animateController.value) * 600}');
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/Images/background_container.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Center(
              child: Container(
                height: 1000 * (_animateController.value),
                width: 1000 * (_animateController.value),
                // color: Colors.orange,
                //TODO: CLosing Container
                decoration: BoxDecoration(
                  color: Colors.white,
                  // gradient: RadialGradient(
                  //     colors: [Color(0xffe8b781), Color(0xfff7c784)]),
                  borderRadius: BorderRadius.circular(
                      (1 - _animateController.value) * 600),
                ),

                child: Column(
                  children: [
                    if (iamhere)
                      SizedBox(
                        height: _height * 0.65,
                      ),
                    if (iamhere)
                      // Text(
                      //   'Check Kiya Kya',
                      //   style: GoogleFonts.pacifico(
                      //     color: Colors.brown,
                      //     fontSize: 30,
                      //   ),
                      // ),
                      Image.asset(
                        'assets/Images/text.png',
                        height: _height * 0.06,
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
                  //TODO: Opening Container
                  //color: Colors.orange[200],
                  // gradient: RadialGradient(colors: [
                  //   Colors.pink,
                  //   Colors.blue,
                  //   Colors.orange,
                  //   Colors.brown
                  // ]),
                  // gradient: RadialGradient(colors: [
                  //   Color(0xfff3bb72),
                  //   Color(0xfff4b97a),
                  //   Color(0xfff9b59a),
                  //   Color(0xffa9bcc4),
                  //   Color(0xff7e8ecf),
                  // ]),
                  image: DecorationImage(
                    image: AssetImage('assets/Images/background.png'),
                    fit: BoxFit.fill,
                  ),
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
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: logoImage,
                        //color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
