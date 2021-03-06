import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_news_detector/Screens/SearchSheetBuilder.dart';
import 'package:fake_news_detector/Utilities/Analyzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:fake_news_detector/Screens/BottomSheetBuilder.dart';
import 'package:fake_news_detector/Widget/CircularProgress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googleapis/chat/v1.dart';

class AppBody extends StatefulWidget {
  static const String id = 'news_tracking_screen';
  static TextEditingController controller;
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> with TickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  AnimationController _animationController;
  AnimationController _rotationController;
  Animation _animation;
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
    AppBody.controller = TextEditingController();
    _animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: percentage).animate(
        CurvedAnimation(parent: _rotationController, curve: Curves.linear));
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
  double end;
  SizedBox changeClicked() {
    print('change Clicked');
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

        Future.delayed(Duration(milliseconds: 2300), () {
          _rotationController.repeat();
          _rotationController.forward();
        });
        AppBody.controller.addListener(() {
          setState(() {});
        });
        _animationController.repeat();

        _animationController.forward();

        _animationController.addListener(() {
          // print('${_animationController.value}' + 'me');
          setState(() {});
        });
        _rotationController.addListener(() {
          //  print('${_rotationController.value}' + 'notme');
          setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    AppBody.controller.dispose();
    _animationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    final _size = MediaQuery.of(context).size;
    // print('${_width * 0.4688}');
    end = _rotationController.value.toDouble() *
            percentage.toDouble() *
            0.5 /
            100.0 -
        0.25;
    //print('${_rotationController.value} + $end');
    // print(check);
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
            child: Stack(children: [
              SingleChildScrollView(
                child: Container(
                  height: _height,
                  decoration: BoxDecoration(),
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
                            onTap: () {
                              showModalBottomSheet(
                                backgroundColor: Colors.black.withOpacity(0),
                                context: context,
                                isScrollControlled: true,
                                elevation: 10,
                                enableDrag: true,
                                builder: (context) => SearchSheetBuilder(
                                  initialText: AppBody.controller.text,
                                ),
                              );
                            },
                            maxLines: 200,
                            textAlignVertical: TextAlignVertical.bottom,
                            enableInteractiveSelection: true,
                            controller: AppBody.controller,
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
                                Container(
                                  width: _width,
                                  child: CircularPercentIndicator(
                                    curve: Curves.linear,
                                    //restartAnimation: true,
                                    // backgroundColor: Colors.white,
                                    animationDuration: 2400,
                                    backgroundWidth: _width * 0.07,
                                    arcType: ArcType.HALF,
                                    arcBackgroundColor: Colors.transparent,
                                    radius: _width * 0.6,
                                    lineWidth: _width * 0.05,
                                    animation: true,

                                    percent: (hasClicked)
                                        ? (percentage *
                                                _animationController.value) /
                                            100
                                        : 0,
                                    center: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        RotationTransition(
                                          turns: Tween(
                                                  begin: -0.25,
                                                  end: (hasClicked)
                                                      ? end
                                                      : -0.25)
                                              .animate(CurvedAnimation(
                                                  curve: Curves.linear,
                                                  parent: _rotationController)),
                                          child: SvgPicture.asset(
                                            'assets/Images/arrow.svg',
                                            color: Colors.white,
                                            height: _height * _width * 0.00068,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/Images/circle.svg',
                                          height: _height * _width * 0.00048,
                                        ),
                                        Text(
                                          (hasClicked)
                                              ? "${(_rotationController.value * percentage).toInt()}%"
                                              : "%",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: _height * 0.04),
                                        ),
                                      ],
                                    ),
                                    // footer: Text(
                                    //   "Fake",
                                    //   style: TextStyle(
                                    //       color: Colors.white,
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: _height * 0.03),
                                    // ),
                                    addAutomaticKeepAlive: true,
                                    fillColor: Colors.transparent,
                                    // maskFilter:
                                    //     MaskFilter.blur(BlurStyle.solid, 1),
                                    rotateLinearGradient: false,

                                    backgroundColor: Colors.white,
                                    //restartAnimation: true,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    linearGradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(gradientBottomContainer),
                                          Color(gradientTopContainer),
                                          //Colors.red,
                                          //Colors.amber
                                        ],
                                        stops: [
                                          0.0,
                                          1.1,
                                          // 2.2,
                                          // 3.3
                                        ]
                                        // tileMode: TileMode.clamp,
                                        ),
                                    // progressColor: Colors.accents[1],
                                    // progressColor: Colors.white,
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
                          !hasInternet ||
                          (onVerifyClick && !hasClicked))
                        Container(
                          padding: EdgeInsets.only(
                              //top: _height * 0.05,
                              bottom: _height * 0.05,
                              left: _width * 0.05,
                              right: _width * 0.05),
                          child: Text(
                            !(onVerifyClick && !hasClicked)
                                ? message
                                : 'No result has been found on your query.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            hasClicked = false;
                          });
                          if (AppBody.controller.text != null)
                            _handleSubmitted(AppBody.controller.text);
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(gradientTopContainer)),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
