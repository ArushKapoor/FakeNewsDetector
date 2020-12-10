import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_news_detector/Utilities/Analyzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:fake_news_detector/Screens/BottomSheetBuilder.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AppBody extends StatefulWidget {
  static const String id = 'news_tracking_screen';
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> with TickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _controller;
  AnimationController _animationController;
  AnimationController _animationWidgetController;
  String wish, imgSrc;
  int wishClr = 0xffE7E7E7;
  int backClr = 0xff181800;
  int gradientTopContainer = 0xff847fca;
  int gradientBottomContainer = 0xffc294ae;
  int gradientTopButton = 0xffba91b1;
  int gradientBottomButton = 0xffc294ae;
  int checkTextClr = 0xff62868E;
  bool hasClicked = false;

  void timing() {
    int hour = DateTime.now().hour;
    setState(() {
      hour = 18;
      if (hour > 5 && hour < 12) {
        wish = 'Good Morning';
        imgSrc = 'assets/Images/morning.jpeg';
        backClr = 0xff181800;
        wishClr = 0xff62868e;
        gradientTopContainer = 0xff1f6599;
        gradientBottomContainer = 0xffc7d1c9;
        gradientTopButton = 0xffb9c8c5;
        gradientBottomButton = 0xffc7d1c9;
        checkTextClr = 0xff62868E;
      } else if (hour > 12 && hour < 17) {
        wish = 'Good Afternoon';
        imgSrc = 'assets/Images/Noon.jpeg';
        backClr = 0xff977c54;
        wishClr = 0xff865c3e;
        gradientTopContainer = 0xff977c53;
        gradientBottomContainer = 0xffd4b29a;
        gradientTopButton = 0xffcdab91;
        gradientBottomButton = 0xffcdab91;
        checkTextClr = 0xff856C3E;
      } else if (hour > 17 && hour < 20) {
        wish = 'Good Evening';
        imgSrc = 'assets/Images/evening.jpeg';
        backClr = 0xff847fca;
        wishClr = 0xff7078d3;
        gradientTopContainer = 0xff847fca;
        gradientBottomContainer = 0xffc294ae;
        gradientTopButton = 0xffba91b1;
        gradientBottomButton = 0xffc294ae;
        checkTextClr = 0xff7078D3;
      } else {
        wish = 'Good Night';
        imgSrc = 'assets/Images/night.jpeg';
        backClr = 0xff1f1e43;
        wishClr = 0xff3b3657;
        gradientTopContainer = 0xff272445;
        gradientBottomContainer = 0xff5e5370;
        gradientTopButton = 0xff5e5370;
        gradientBottomButton = 0xff5e5370;
        checkTextClr = 0xff3B3657;
      }
    });
  }

  // Animation _animation;
  bool onVerifyClick = false;
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    timing();
    _controller = TextEditingController();
    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _animationWidgetController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    // _animation =
    //     CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle);
  }

  int percent = 0;
  int percentage = 0;
  bool isAlreadyANews = false;
  bool noMatchFound = false;
  bool noResultFound = false;
  bool isEaster = false;
  bool hasInternet = true;
  String message = '';
  String viewPage = '';
  SizedBox changeClicked() {
    setState(() {
      hasClicked = true;
    });

    return SizedBox();
  }

  void _handleSubmitted(String text) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          hasInternet = true;
          // onVerifyClick = true;
          message = '';
        });
      }
    } on SocketException catch (_) {
      setState(() {
        hasInternet = false;
        // onVerifyClick = false;
        message = 'No Internet Connection';
      });
    }
    String smallText = text.toLowerCase();
    if (smallText.contains('i am ceo of google')) {
      setState(() {
        isEaster = true;
        message = 'Aji 🔔😝';
      });
    } else {
      setState(() {
        isEaster = false;
      });
    }
    if (hasInternet) {
      if (text.isNotEmpty) {
        setState(() {
          isVisible = true;
          onVerifyClick = false;
        });
        Analyzer networking = Analyzer();
        percent = await networking.query(text);
        if (Analyzer.descriptionToSend != null &&
            Analyzer.imageLinkToSend != null &&
            Analyzer.titleToSend != null &&
            Analyzer.imageLinkToSend != null &&
            Analyzer.formattedUrlToSend != null) {
          viewPage = '\nClick on View Page for more details';
        }
        if (Analyzer.noMatchFound) {
          setState(() {
            noMatchFound = true;
            message = 'No match has been found on your query.$viewPage';
          });
          // print('No match has been found');
        } else {
          setState(() {
            noMatchFound = false;
          });
        }
        if (Analyzer.noResultFound) {
          // print('No result has been found');
          setState(() {
            noResultFound = true;
            message = 'No result has been found on your query.';
          });
        } else {
          setState(() {
            noResultFound = false;
          });
        }
        //print(percent);
        percentage = percent;
        // print(percentage);
        int counter = 0;
        String id;
        final newses = await _firestore.collection('news').get();
        for (var news in newses.docs) {
          if (news.data().containsValue(Analyzer.descriptionToSend) &&
              news.data().containsValue(Analyzer.siteNameToSend) &&
              news.data().containsValue(Analyzer.imageLinkToSend) &&
              news.data().containsValue(Analyzer.formattedUrlToSend) &&
              news.data().containsValue(Analyzer.titleToSend)) {
            isAlreadyANews = true;
            counter = news.data()['count'];
            //print(news.data()['count']);
            id = news.id;
          }
        }
        if (!noMatchFound) {
          if (isAlreadyANews &&
              Analyzer.descriptionToSend != null &&
              Analyzer.siteNameToSend != null &&
              Analyzer.imageLinkToSend != null &&
              Analyzer.titleToSend != null &&
              Analyzer.formattedUrlToSend != null &&
              percentage > 50) {
            await _firestore.collection('news').doc(id).set({
              'description': Analyzer.descriptionToSend,
              'sitename': Analyzer.siteNameToSend,
              'img': Analyzer.imageLinkToSend,
              'time': DateTime.now(),
              'title': Analyzer.titleToSend,
              'url': Analyzer.formattedUrlToSend,
              'count': ++counter,
            });
          }
          if (isAlreadyANews == false &&
              Analyzer.descriptionToSend != null &&
              Analyzer.siteNameToSend != null &&
              Analyzer.imageLinkToSend != null &&
              Analyzer.titleToSend != null &&
              Analyzer.formattedUrlToSend != null &&
              percentage > 50) {
            _firestore.collection('news').add({
              // 'snippet': Analyzer.snippetToSend,
              'description': Analyzer.descriptionToSend,
              'sitename': Analyzer.siteNameToSend,
              'img': Analyzer.imageLinkToSend,
              'time': DateTime.now(),
              'title': Analyzer.titleToSend,
              'url': Analyzer.formattedUrlToSend,
              'count': 0,
            });
          }
        }
        setState(() {
          percentage = percent;
          onVerifyClick = true;
          isVisible = false;
        });

        _animationController.repeat();
        _animationController.forward();
        _animationWidgetController.repeat();
        _animationWidgetController.forward();

        _animationWidgetController.addListener(() {
          setState(() {});
        });
        _animationController.addListener(() {
          setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _animationWidgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    print('${_width * 0.4688}');
    // backClr = 0xff181800;
    // wishClr = 0xff62868e;
    // gradientTopContainer = 0xff5d848f;
    // gradientBottomContainer = 0xfffed062;
    // gradientTopButton = 0xffb9c8c5;
    // gradientBottomButton = 0xffc7d1c9;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(gradientTopContainer),
            Color(gradientBottomContainer),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: EdgeInsets.only(top: _height * 0.075),
              child: Stack(children: [
                SingleChildScrollView(
                  child: Container(
                    height: _height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Color(gradientTopContainer),
                          Color(gradientBottomContainer)
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: _height * 0.05,
                              left: _width * 0.05,
                              right: _width * 0.05),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            padding:
                                EdgeInsets.symmetric(horizontal: _width * 0.04),
                            width: _width,
                            height: _height * 0.07,
                            child: TextField(
                              maxLines: 200,
                              textAlignVertical: TextAlignVertical.bottom,
                              enableInteractiveSelection: true,
                              controller: _controller,
                              keyboardType: TextInputType.multiline,
                              scrollController: ScrollController(),
                              showCursor: true,
                              cursorColor: Colors.green,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8.0),
                                prefixIcon: Icon(Icons.search),
                                fillColor: Color(0xff000000),
                                border: InputBorder.none,
                                hintText: 'Enter your query',
                                hintStyle: TextStyle(fontSize: _height * 0.03),
                              ),
                              style: TextStyle(
                                fontSize: _height * 0.03,
                              ),
                              scrollPhysics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: _height * 0.2,
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: LayoutBuilder(
                            builder: (context, constraints) => Container(
                              width: _width,
                              child: Stack(
                                children: <Widget>[
                                  LayoutBuilder(
                                    builder: (context, constraints) =>
                                        Container(
                                      margin: EdgeInsets.only(
                                        left: constraints.maxWidth * 0.25,
                                      ),
                                      child: CircularPercentIndicator(
                                        backgroundColor: (hasClicked)
                                            ? Colors.black.withOpacity(0)
                                            : Colors.white,
                                        animationDuration: 500,
                                        backgroundWidth:
                                            constraints.maxWidth * 0.06,
                                        arcType: ArcType.HALF,
                                        arcBackgroundColor: Color(0xff8980C8),
                                        radius: constraints.maxWidth * 0.48,
                                        lineWidth: constraints.maxWidth * 0.04,
                                        animation: true,

                                        // percent: (_animationWidgetController.value *
                                        //         percentage) /
                                        //     100,
                                        percent: 0,
                                        center: Text(
                                          (hasClicked)
                                              ? "${(_animationController.value * percentage).toInt()}%"
                                              : "%",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: _height * 0.06),
                                        ),
                                        footer: Text(
                                          "Fake",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: _height * 0.03),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        linearGradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.green,
                                            Colors.red,
                                          ],
                                          // tileMode: TileMode.clamp,
                                        ),
                                        // progressColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: constraints.maxWidth * 0.234,
                                      top: constraints.maxHeight * 0.373,
                                    ),
                                    child: RotatedBox(
                                      quarterTurns: 2,
                                      child: ClipPath(
                                        clipper: ArcClipper(
                                            height: _height, width: _width),
                                        child: Container(
                                          // margin: EdgeInsets.only(
                                          //     top: _height * 0.2,
                                          //     left: _width * 0.25),
                                          height: constraints.maxHeight * 0.18,
                                          width: constraints.maxWidth * 0.08,
                                          decoration: BoxDecoration(
                                            // gradient: LinearGradient(
                                            //     begin: FractionalOffset.topCenter,
                                            //     end:
                                            //         FractionalOffset.bottomCenter,
                                            //     colors: [
                                            //       Color(0xffA189BD),
                                            //       Color(0xffA88BBA),
                                            //     ],
                                            //     stops: [
                                            //       0.0,
                                            //       1.0
                                            //     ]),
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: constraints.maxHeight * 0.48,
                                      left: constraints.maxWidth * 0.26,
                                    ),
                                    height: constraints.maxHeight * 0.13,
                                    width: constraints.maxWidth * 0.11,
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //     begin: FractionalOffset.topCenter,
                                      //     end: FractionalOffset.bottomCenter,
                                      //     colors: [
                                      //       Color(0xffA48ABC),
                                      //       Color(0xffA88BBA),
                                      //     ],
                                      //     stops: [
                                      //       0.0,
                                      //       1.0
                                      //     ]),
                                      color: Colors.teal,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: constraints.maxHeight * 0.353,
                                        left: constraints.maxWidth * 0.67),
                                    child: RotatedBox(
                                      quarterTurns: 2,
                                      child: ClipPath(
                                        clipper: ArcClipper(
                                            height: _height, width: _width),
                                        child: Container(
                                          // margin: EdgeInsets.only(
                                          //     top: _height * 0.2,
                                          //     left: _width * 0.25),
                                          height: constraints.maxHeight * 0.20,
                                          width: constraints.maxWidth * 0.082,
                                          decoration: BoxDecoration(
                                            // gradient: LinearGradient(
                                            //     begin: FractionalOffset.topCenter,
                                            //     end: FractionalOffset.bottomCenter,
                                            //     colors: [
                                            //       Color(0xffA189BD),
                                            //       Color(0xffA88BBA),
                                            //     ],
                                            //     stops: [
                                            //       0.0,
                                            //       1.0
                                            //     ]),
                                            color: Colors.teal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: constraints.maxHeight * 0.460,
                                        left: constraints.maxWidth * 0.61),
                                    height: constraints.maxHeight * 0.13,
                                    width: constraints.maxWidth * 0.11,
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //     begin: FractionalOffset.topCenter,
                                      //     end: FractionalOffset.bottomCenter,
                                      //     colors: [
                                      //       Color(0xffA48ABC),
                                      //       Color(0xffA88BBA),
                                      //     ],
                                      //     stops: [
                                      //       0.0,
                                      //       1.0
                                      //     ]),
                                      color: Colors.teal,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: constraints.maxWidth * 0.25,
                                      top: constraints.maxHeight * 0.58,
                                    ),
                                    height: constraints.maxHeight * 0.16,
                                    width: constraints.maxWidth * 0.48,
                                    decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //     begin: FractionalOffset.topCenter,
                                      //     end: FractionalOffset.bottomCenter,
                                      //     colors: [
                                      //       Color(0xffA88BBA),
                                      //       Color(0xffAC8DB8),
                                      //     ],
                                      //     stops: [
                                      //       0.0,
                                      //       1.0
                                      //     ]),
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: _height * 0.1,
                        ),
                        // if (onVerifyClick &&
                        //     !noMatchFound &&
                        //     !noResultFound &&
                        //     !isEaster)
                        // Container(
                        //   padding: EdgeInsets.only(bottom: _height * 0.05),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       verifyText(
                        //           isFake: false,
                        //           percentage: (percentage != 0
                        //                   ? 100 -
                        //                       (_animation.value * percentage)
                        //                   : _animation.value * 100)
                        //               .toInt()
                        //               .toString()),
                        //       SizedBox(
                        //         width: _width * 0.15,
                        //       ),
                        //       verifyText(
                        //           isFake: true,
                        //           percentage: (percentage != 0
                        //                   ? _animation.value * percentage
                        //                   : (100 - _animation.value * 100))
                        //               .toInt()
                        //               .toString()),
                        //     ],
                        //   ),
                        // ),
                        if (noMatchFound ||
                            noResultFound ||
                            isEaster ||
                            !hasInternet)
                          Container(
                            padding: EdgeInsets.only(
                                //top: _height * 0.05,
                                bottom: _height * 0.05,
                                left: _width * 0.05,
                                right: _width * 0.05),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            if (_controller.text != null)
                              _handleSubmitted(_controller.text);
                          },
                          child: Container(
                            // padding: EdgeInsets.only(bottom: _height * 0.02),
                            width: _width * 0.28,
                            height: _height * 0.09,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(_width * 0.025))),
                            child: Center(
                              child: Text(
                                'CHECK',
                                style: TextStyle(
                                    fontSize: _height * 0.03,
                                    color: Color(checkTextClr)),
                              ),
                            ),
                          ),
                        ),

                        if (onVerifyClick &&
                            !noResultFound &&
                            !isEaster &&
                            Analyzer.descriptionToSend != null &&
                            Analyzer.imageLinkToSend != null &&
                            Analyzer.titleToSend != null &&
                            Analyzer.formattedUrlToSend != null)
                          changeClicked(),

                        if (onVerifyClick &&
                            !noResultFound &&
                            !isEaster &&
                            Analyzer.descriptionToSend != null &&
                            Analyzer.imageLinkToSend != null &&
                            Analyzer.titleToSend != null &&
                            Analyzer.formattedUrlToSend != null)
                          Container(
                            margin: EdgeInsets.only(top: _height * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  elevation: 10,
                                  enableDrag: true,
                                  builder: (context) => SingleChildScrollView(
                                    child: BottomSheetBuilder(
                                      imageLink: Analyzer.imageLinkToSend,
                                      siteName: Analyzer.siteNameToSend,
                                      snippet: Analyzer.descriptionToSend,
                                      title: Analyzer.titleToSend,
                                      url: Analyzer.formattedUrlToSend,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(),
                                child: Text(
                                  'View Source',
                                  style: TextStyle(
                                      fontSize: _height * 0.028,
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (isVisible)
                  Opacity(
                    opacity: 0.60,
                    child: Container(
                      height: _height,
                      width: _width,
                    ),
                  ),
                if (isVisible)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  final double height;
  final double width;

  ArcClipper({this.height, this.width});
  @override
  Path getClip(Size size) {
    print('${width * 0.08} + ${size.width}');
    var path = Path();
    path.lineTo(0.0, height * 0.092);
    path.quadraticBezierTo(
        width * 0.08 * 0.5,
        height * 0.092 - (height * 0.092 * 0.56),
        width * 0.08 + (width * 0.08 * 0.1),
        height * 0.092);
    path.lineTo(width * 0.08, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
