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
      } else if (hour > 12 && hour < 17) {
        wish = 'Good Afternoon';
        imgSrc = 'assets/Images/Noon.jpeg';
        backClr = 0xff977c54;
        wishClr = 0xff865c3e;
        gradientTopContainer = 0xff977c53;
        gradientBottomContainer = 0xffd4b29a;
        gradientTopButton = 0xffcdab91;
        gradientBottomButton = 0xffcdab91;
      } else if (hour > 17 && hour < 20) {
        wish = 'Good Evening';
        imgSrc = 'assets/Images/evening.jpeg';
        backClr = 0xff847fca;
        wishClr = 0xff7078d3;
        gradientTopContainer = 0xff847fca;
        gradientBottomContainer = 0xffc294ae;
        gradientTopButton = 0xffba91b1;
        gradientBottomButton = 0xffc294ae;
      } else {
        wish = 'Good Night';
        imgSrc = 'assets/Images/night.jpeg';
        backClr = 0xff1f1e43;
        wishClr = 0xff3b3657;
        gradientTopContainer = 0xff272445;
        gradientBottomContainer = 0xff5e5370;
        gradientTopButton = 0xff5e5370;
        gradientBottomButton = 0xff5e5370;
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
    backClr = 0xff181800;
    wishClr = 0xff62868e;
    gradientTopContainer = 0xff1f6599;
    gradientBottomContainer = 0xffc7d1c9;
    gradientTopButton = 0xffb9c8c5;
    gradientBottomButton = 0xffc7d1c9;
    return Scaffold(
      backgroundColor: Color(gradientTopContainer),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                        Color(gradientTopContainer),
                        Color(gradientBottomContainer)
                      ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: _height * 0.1,
                            left: _width * 0.05,
                            right: _width * 0.05),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                      //if (noMatchFound && noResultFound)
                      Padding(
                        padding: EdgeInsets.only(
                            top: _height * 0.18, bottom: _height * 0.18),
                        child: Center(
                          child: CircularPercentIndicator(
                              animationDuration: 500,
                              radius: 150.0,
                              lineWidth: 13.0,
                              animation: true,
                              percent: (_animationWidgetController.value *
                                      percentage) /
                                  100,
                              center: Text(
                                "${(_animationController.value * percentage).toInt()}%",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              footer: Text(
                                "Fake",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Color(0xff45BB78)),
                        ),
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
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.only(top: _height * 0.02),
                        width: _width * 0.55,
                        height: _height * 0.1,
                        decoration: BoxDecoration(color: Colors.white),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          onPressed: () {
                            if (_controller.text != null)
                              _handleSubmitted(_controller.text);
                          },
                          color: Color(0xff45BB78),
                          child: Text(
                            'CHECK',
                            style: TextStyle(
                                fontSize: _height * 0.03, color: Colors.white),
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
                            child: Text(
                              'View Source',
                              style: TextStyle(
                                  fontSize: _height * 0.028,
                                  color: Color(0xff45BB78),
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isVisible)
                  Opacity(
                    opacity: 0.60,
                    child: Container(
                      color: Colors.grey[100],
                      height: _height,
                      width: _width,
                    ),
                  ),
                if (isVisible)
                  Center(
                    child: const SpinKitThreeBounce(
                      color: Colors.blue,
                      size: 20.0,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_news_detector/Utilities/Analyzer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'dart:io';
// import 'package:fake_news_detector/Screens/BottomSheetBuilder.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class AppBody extends StatefulWidget {
//   static const String id = 'news_tracking_screen';
//   @override
//   _AppBodyState createState() => _AppBodyState();
// }

// class _AppBodyState extends State<AppBody> with TickerProviderStateMixin {
//   final _firestore = FirebaseFirestore.instance;
//   TextEditingController _controller;
//   AnimationController _animationController;
//   AnimationController _animationWidgetController;
//   Animation _animation;
//   bool onVerifyClick = false;
//   bool isVisible = false;
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//     _animationController = AnimationController(
//       duration: Duration(seconds: 5),
//       vsync: this,
//     );
//     _animationWidgetController = AnimationController(
//       duration: Duration(seconds: 5),
//       vsync: this,
//     );
//     _animation =
//         CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle);
//   }

//   int percent = 0;
//   int percentage = 0;
//   bool isAlreadyANews = false;
//   bool noMatchFound = false;
//   bool noResultFound = false;
//   bool isEaster = false;
//   bool hasInternet = true;
//   String message = '';
//   String viewPage = '';
//   void _handleSubmitted(String text) async {
//     FocusScopeNode currentFocus = FocusScope.of(context);

//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         setState(() {
//           hasInternet = true;
//           // onVerifyClick = true;
//           message = '';
//         });
//       }
//     } on SocketException catch (_) {
//       setState(() {
//         hasInternet = false;
//         // onVerifyClick = false;
//         message = 'No Internet Connection';
//       });
//     }
//     String smallText = text.toLowerCase();
//     if (smallText.contains('i am ceo of google')) {
//       setState(() {
//         isEaster = true;
//         message = 'Aji 🔔😝';
//       });
//     } else {
//       setState(() {
//         isEaster = false;
//       });
//     }
//     if (hasInternet) {
//       if (text.isNotEmpty) {
//         setState(() {
//           isVisible = true;
//           onVerifyClick = false;
//         });
//         Analyzer networking = Analyzer();
//         percent = await networking.query(text);
//         if (Analyzer.descriptionToSend != null &&
//             Analyzer.imageLinkToSend != null &&
//             Analyzer.titleToSend != null &&
//             Analyzer.imageLinkToSend != null &&
//             Analyzer.formattedUrlToSend != null) {
//           viewPage = '\nClick on View Page for more details';
//         }
//         if (Analyzer.noMatchFound) {
//           setState(() {
//             noMatchFound = true;
//             message = 'No match has been found on your query.$viewPage';
//           });
//           // print('No match has been found');
//         } else {
//           setState(() {
//             noMatchFound = false;
//           });
//         }
//         if (Analyzer.noResultFound) {
//           // print('No result has been found');
//           setState(() {
//             noResultFound = true;
//             message = 'No result has been found on your query.';
//           });
//         } else {
//           setState(() {
//             noResultFound = false;
//           });
//         }
//         //print(percent);
//         percentage = percent;
//         // print(percentage);
//         int counter = 0;
//         String id;
//         final newses = await _firestore.collection('news').get();
//         for (var news in newses.docs) {
//           if (news.data().containsValue(Analyzer.descriptionToSend) &&
//               news.data().containsValue(Analyzer.siteNameToSend) &&
//               news.data().containsValue(Analyzer.imageLinkToSend) &&
//               news.data().containsValue(Analyzer.formattedUrlToSend) &&
//               news.data().containsValue(Analyzer.titleToSend)) {
//             isAlreadyANews = true;
//             counter = news.data()['count'];
//             //print(news.data()['count']);
//             id = news.id;
//           }
//         }
//         if (!noMatchFound) {
//           if (isAlreadyANews &&
//               Analyzer.descriptionToSend != null &&
//               Analyzer.siteNameToSend != null &&
//               Analyzer.imageLinkToSend != null &&
//               Analyzer.titleToSend != null &&
//               Analyzer.formattedUrlToSend != null &&
//               percentage > 50) {
//             await _firestore.collection('news').doc(id).set({
//               'description': Analyzer.descriptionToSend,
//               'sitename': Analyzer.siteNameToSend,
//               'img': Analyzer.imageLinkToSend,
//               'time': DateTime.now(),
//               'title': Analyzer.titleToSend,
//               'url': Analyzer.formattedUrlToSend,
//               'count': ++counter,
//             });
//           }
//           if (isAlreadyANews == false &&
//               Analyzer.descriptionToSend != null &&
//               Analyzer.siteNameToSend != null &&
//               Analyzer.imageLinkToSend != null &&
//               Analyzer.titleToSend != null &&
//               Analyzer.formattedUrlToSend != null &&
//               percentage > 50) {
//             _firestore.collection('news').add({
//               // 'snippet': Analyzer.snippetToSend,
//               'description': Analyzer.descriptionToSend,
//               'sitename': Analyzer.siteNameToSend,
//               'img': Analyzer.imageLinkToSend,
//               'time': DateTime.now(),
//               'title': Analyzer.titleToSend,
//               'url': Analyzer.formattedUrlToSend,
//               'count': 0,
//             });
//           }
//         }
//         setState(() {
//           percentage = percent;
//           onVerifyClick = true;
//           isVisible = false;
//         });

//         _animationController.repeat();
//         _animationController.forward();

//         _animationController.addListener(() {
//           setState(() {});
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _height = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     final _width = MediaQuery.of(context).size.width;

//     Column verifyText({bool isFake, String percentage}) {
//       String text;
//       Color iconColor;
//       if (isFake) {
//         text = 'Incorrect';
//         iconColor = Colors.red;
//       } else {
//         text = 'Correct';
//         iconColor = Colors.green;
//       }

//       return Column(
//         children: [
//           Icon(
//             Icons.check_circle,
//             color: iconColor,
//             size: _width * 0.1,
//           ),
//           SizedBox(
//             height: _height * 0.015,
//           ),
//           Text(
//             '$percentage%',
//             style: TextStyle(fontSize: _height * 0.03, color: iconColor),
//           ),
//         ],
//       );
//     }

//     return Scaffold(
//       backgroundColor: Color(0xffFFF1BA),
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: Stack(
//             children: <Widget>[
//               SingleChildScrollView(
//                 child: Container(
//                   margin: EdgeInsets.only(
//                       top: _height * 0.05, bottom: _height * 0.05),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: _height * 0.1,
//                             left: _width * 0.05,
//                             right: _width * 0.05),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(15.0)),
//                           ),
//                           padding: EdgeInsets.symmetric(horizontal: 10.0),
//                           width: _width,
//                           height: _height * 0.07,
//                           child: TextField(
//                             maxLines: 200,
//                             textAlignVertical: TextAlignVertical.bottom,
//                             enableInteractiveSelection: true,
//                             controller: _controller,
//                             keyboardType: TextInputType.multiline,
//                             scrollController: ScrollController(),
//                             showCursor: true,
//                             cursorColor: Colors.green,
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.all(8.0),
//                               prefixIcon: Icon(Icons.search),
//                               fillColor: Color(0xff000000),
//                               border: InputBorder.none,
//                               hintText: 'Enter your query',
//                               hintStyle: TextStyle(fontSize: _height * 0.03),
//                             ),
//                             style: TextStyle(
//                               fontSize: _height * 0.03,
//                             ),
//                             scrollPhysics: BouncingScrollPhysics(
//                                 parent: AlwaysScrollableScrollPhysics()),
//                           ),
//                         ),
//                       ),
//                       if (onVerifyClick &&
//                           noMatchFound &&
//                           !noResultFound &&
//                           !isEaster)
//                         Padding(
//                           padding: EdgeInsets.only(
//                               top: _height * 0.15, bottom: _height * 0.15),
//                           child: Center(
//                             child: CircularPercentIndicator(
//                                 animationDuration: 500,
//                                 radius: 120.0,
//                                 lineWidth: 13.0,
//                                 animation: true,
//                                 percent: (percentage) / 100,
//                                 center: Text(
//                                   "${(_animationWidgetController.value * percentage).toInt()}%",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 20.0),
//                                 ),
//                                 footer: new Text(
//                                   "Fake",
//                                   style: new TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 17.0),
//                                 ),
//                                 circularStrokeCap: CircularStrokeCap.round,
//                                 progressColor: Color(0xff45BB78)),
//                           ),
//                         ),
//                       if (noMatchFound ||
//                           noResultFound ||
//                           isEaster ||
//                           !hasInternet)
//                         Container(
//                           padding: EdgeInsets.only(
//                               bottom: _height * 0.05,
//                               left: _width * 0.05,
//                               right: _width * 0.05),
//                           child: Text(
//                             message,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                       Container(
//                         width: _width * 0.55,
//                         height: _height * 0.09,
//                         child: FlatButton(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15.0),
//                           ),
//                           onPressed: () {
//                             if (_controller.text != null)
//                               _handleSubmitted(_controller.text);
//                           },
//                           color: Color(0xffff841b),
//                           child: Text(
//                             'VERIFY',
//                             style: TextStyle(
//                                 fontSize: _height * 0.03, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                       if (onVerifyClick &&
//                           !noResultFound &&
//                           !isEaster &&
//                           Analyzer.descriptionToSend != null &&
//                           Analyzer.imageLinkToSend != null &&
//                           Analyzer.titleToSend != null &&
//                           Analyzer.formattedUrlToSend != null)
//                         Container(
//                           margin: EdgeInsets.only(top: _height * 0.05),
//                           child: GestureDetector(
//                             onTap: () {
//                               showModalBottomSheet(
//                                 context: context,
//                                 isScrollControlled: true,
//                                 elevation: 10,
//                                 enableDrag: true,
//                                 builder: (context) => SingleChildScrollView(
//                                   child: BottomSheetBuilder(
//                                     imageLink: Analyzer.imageLinkToSend,
//                                     siteName: Analyzer.siteNameToSend,
//                                     snippet: Analyzer.descriptionToSend,
//                                     title: Analyzer.titleToSend,
//                                     url: Analyzer.formattedUrlToSend,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               'View Page',
//                               style: TextStyle(
//                                   fontSize: _height * 0.028,
//                                   color: Color(0xffff841b),
//                                   decoration: TextDecoration.underline),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (isVisible)
//                 Opacity(
//                   opacity: 0.60,
//                   child: Container(
//                     color: Colors.grey[100],
//                     height: _height,
//                     width: _width,
//                   ),
//                 ),
//               if (isVisible)
//                 Center(
//                   child: const SpinKitThreeBounce(
//                     color: Colors.blue,
//                     size: 20.0,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fake_news_detector/Utilities/Analyzer.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:fake_news_detector/Screens/BottomSheetBuilder.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// class AppBody extends StatefulWidget {
//   static const String id = 'news_tracking_screen';
//   @override
//   _AppBodyState createState() => _AppBodyState();
// }

// class _AppBodyState extends State<AppBody> with TickerProviderStateMixin {
//   final _firestore = FirebaseFirestore.instance;
//   TextEditingController _controller;
//   AnimationController _animationController;
//   Animation _animation;
//   bool onVerifyClick = false;
//   bool isVisible = false;
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController();
//     _animationController = AnimationController(
//       duration: Duration(seconds: 5),
//       vsync: this,
//     );
//     _animation =
//         CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle);
//   }

//   int percent = 0;
//   int percentage = 0;
//   bool isAlreadyANews = false;
//   bool noMatchFound = false;
//   bool noResultFound = false;
//   bool isEaster = false;
//   bool hasInternet = true;
//   String message = '';
//   String viewPage = '';
//   void _handleSubmitted(String text) async {
//     FocusScopeNode currentFocus = FocusScope.of(context);

//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         setState(() {
//           hasInternet = true;
//           // onVerifyClick = true;
//           message = '';
//         });
//       }
//     } on SocketException catch (_) {
//       setState(() {
//         hasInternet = false;
//         // onVerifyClick = false;
//         message = 'No Internet Connection';
//       });
//     }
//     String smallText = text.toLowerCase();
//     if (smallText.contains('i am ceo of google')) {
//       setState(() {
//         isEaster = true;
//         message = 'Aji 🔔😝';
//       });
//     } else {
//       setState(() {
//         isEaster = false;
//       });
//     }
//     if (hasInternet) {
//       if (text.isNotEmpty) {
//         setState(() {
//           isVisible = true;
//           onVerifyClick = false;
//         });
//         Analyzer networking = Analyzer();
//         percent = await networking.query(text);
//         if (Analyzer.descriptionToSend != null &&
//             Analyzer.imageLinkToSend != null &&
//             Analyzer.titleToSend != null &&
//             Analyzer.imageLinkToSend != null &&
//             Analyzer.formattedUrlToSend != null) {
//           viewPage = '\nClick on View Page for more details';
//         }
//         if (Analyzer.noMatchFound) {
//           setState(() {
//             noMatchFound = true;
//             message = 'No match has been found on your query.$viewPage';
//           });
//           // print('No match has been found');
//         } else {
//           setState(() {
//             noMatchFound = false;
//           });
//         }
//         if (Analyzer.noResultFound) {
//           // print('No result has been found');
//           setState(() {
//             noResultFound = true;
//             message = 'No result has been found on your query.';
//           });
//         } else {
//           setState(() {
//             noResultFound = false;
//           });
//         }
//         //print(percent);
//         percentage = percent;
//         // print(percentage);
//         int counter = 0;
//         String id;
//         final newses = await _firestore.collection('news').get();
//         for (var news in newses.docs) {
//           if (news.data().containsValue(Analyzer.descriptionToSend) &&
//               news.data().containsValue(Analyzer.siteNameToSend) &&
//               news.data().containsValue(Analyzer.imageLinkToSend) &&
//               news.data().containsValue(Analyzer.formattedUrlToSend) &&
//               news.data().containsValue(Analyzer.titleToSend)) {
//             isAlreadyANews = true;
//             counter = news.data()['count'];
//             //print(news.data()['count']);
//             id = news.id;
//           }
//         }
//         if (!noMatchFound) {
//           if (isAlreadyANews &&
//               Analyzer.descriptionToSend != null &&
//               Analyzer.siteNameToSend != null &&
//               Analyzer.imageLinkToSend != null &&
//               Analyzer.titleToSend != null &&
//               Analyzer.formattedUrlToSend != null &&
//               percentage > 50) {
//             await _firestore.collection('news').doc(id).set({
//               'description': Analyzer.descriptionToSend,
//               'sitename': Analyzer.siteNameToSend,
//               'img': Analyzer.imageLinkToSend,
//               'time': DateTime.now(),
//               'title': Analyzer.titleToSend,
//               'url': Analyzer.formattedUrlToSend,
//               'count': ++counter,
//             });
//           }
//           if (isAlreadyANews == false &&
//               Analyzer.descriptionToSend != null &&
//               Analyzer.siteNameToSend != null &&
//               Analyzer.imageLinkToSend != null &&
//               Analyzer.titleToSend != null &&
//               Analyzer.formattedUrlToSend != null &&
//               percentage > 50) {
//             _firestore.collection('news').add({
//               // 'snippet': Analyzer.snippetToSend,
//               'description': Analyzer.descriptionToSend,
//               'sitename': Analyzer.siteNameToSend,
//               'img': Analyzer.imageLinkToSend,
//               'time': DateTime.now(),
//               'title': Analyzer.titleToSend,
//               'url': Analyzer.formattedUrlToSend,
//               'count': 0,
//             });
//           }
//         }
//         setState(() {
//           percentage = percent;
//           onVerifyClick = true;
//           isVisible = false;
//         });

//         _animationController.repeat();
//         _animationController.forward();

//         _animationController.addListener(() {
//           setState(() {});
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _height = MediaQuery.of(context).size.height -
//         MediaQuery.of(context).padding.top -
//         kToolbarHeight;
//     final _width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Color(0xffFFF1BA),
//       body: Container(
//         constraints: BoxConstraints.expand(),

//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   margin: EdgeInsets.only(top: _height * 0.15),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(20),
//                     ),
//                   ),
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: TextField(
//                           showCursor: true,
//                           cursorColor: Colors.green,
//                           controller: _controller,
//                           decoration: InputDecoration(
//                             hintText: "Enter your query",
//                             hintStyle: TextStyle(
//                               color: Colors.black,
//                               fontSize: 20,
//                             ),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                       Icon(
//                         Icons.search,
//                         color: Colors.black,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Column(
//                 children: [
//                   Padding(
//                       padding: EdgeInsets.only(
//                           top: _height * 0.25, bottom: _height * 0.2),
//                       child: Center(
//                         child: new CircularPercentIndicator(
//                             radius: 120.0,
//                             lineWidth: 13.0,
//                             animation: true,
//                             percent: (_animation.value * percentage) / 100,
//                             center: new Text(
//                               "${(percentage).toInt()}%",
//                               style: new TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 20.0),
//                             ),
//                             footer: new Text(
//                               "Fake",
//                               style: new TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 17.0),
//                             ),
//                             circularStrokeCap: CircularStrokeCap.round,
//                             progressColor: Color(0xff45BB78)),
//                       ))
//                 ],
//               ),
//               if (noMatchFound || noResultFound || isEaster || !hasInternet)
//                 Container(
//                   padding: EdgeInsets.only(),
//                   child: Text(
//                     message,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               Container(
//                 width: _width * 0.55,
//                 height: _height * 0.09,
//                 child: FlatButton(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   onPressed: () {
//                     if (_controller.text != null)
//                       _handleSubmitted(_controller.text);
//                   },
//                   color: Color(0xff45BB78),
//                   child: Text(
//                     'VERIFY',
//                     style: TextStyle(
//                         fontSize: _height * 0.03, color: Colors.white),
//                   ),
//                 ),
//               ),
//               if (onVerifyClick &&
//                   !noResultFound &&
//                   !isEaster &&
//                   Analyzer.descriptionToSend != null &&
//                   Analyzer.imageLinkToSend != null &&
//                   Analyzer.titleToSend != null &&
//                   Analyzer.formattedUrlToSend != null)
//                 Container(
//                   margin: EdgeInsets.only(top: _height * 0.05),
//                   child: GestureDetector(
//                     onTap: () {
//                       showModalBottomSheet(
//                         context: context,
//                         isScrollControlled: true,
//                         elevation: 10,
//                         enableDrag: true,
//                         builder: (context) => SingleChildScrollView(
//                           child: BottomSheetBuilder(
//                             imageLink: Analyzer.imageLinkToSend,
//                             siteName: Analyzer.siteNameToSend,
//                             snippet: Analyzer.descriptionToSend,
//                             title: Analyzer.titleToSend,
//                             url: Analyzer.formattedUrlToSend,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text(
//                       'View Page',
//                       style: TextStyle(
//                           fontSize: _height * 0.028,
//                           color: Color(0xffff841b),
//                           decoration: TextDecoration.underline),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         // if (isVisible)
//         //   Opacity(
//         //     opacity: 0.60,
//         //     child: Container(
//         //       color: Colors.grey[100],
//         //       height: _height,
//         //       width: _width,
//         //     ),
//         //   ),
//         // if (isVisible)
//         //   Center(
//         //     child: const SpinKitCircle(
//         //       color: Colors.blue,
//         //       size: 20.0,
//         //     ),
//         //   ),
//       ),
//     );

//     // return Scaffold(
//     //   body: SafeArea(
//     //     child: GestureDetector(
//     //       onTap: () {
//     //         FocusScope.of(context).unfocus();
//     //       },
//     //       child: Stack(
//     //         children: <Widget>[
//     //           SingleChildScrollView(
//     //             child: Container(
//     //               child: Column(
//     //                 mainAxisAlignment: MainAxisAlignment.center,
//     //                 children: <Widget>[
//     //                   Padding(
//     //                     padding: EdgeInsets.all(_height * 0.02),
//     //                     child: Container(
//     //                       decoration: BoxDecoration(
//     //                         color: Colors.white,
//     //                         borderRadius:
//     //                             BorderRadius.all(Radius.circular(15.0)),
//     //                         border: Border.all(
//     //                           color: Colors.black,
//     //                           width: 5,
//     //                         ),
//     //                       ),
//     //                       padding: EdgeInsets.symmetric(
//     //                           horizontal: 10.0, vertical: 10.0),
//     //                       width: _width * 0.7,
//     //                       height: _height * 0.2,
//     //                       child: TextField(
//     //                         maxLines: 200,
//     //                         textAlignVertical: TextAlignVertical.bottom,
//     //                         enableInteractiveSelection: true,
//     //                         controller: _controller,
//     //                         keyboardType: TextInputType.multiline,
//     //                         scrollController: ScrollController(),
//     //                         showCursor: true,
//     //                         cursorColor: Colors.green,
//     //                         decoration: InputDecoration.collapsed(
//     //                             fillColor: Color(0xff000000),
//     //                             border: InputBorder.none,
//     //                             hintText: 'Enter your query here',
//     //                             hintStyle: TextStyle(fontSize: _height * 0.03)),
//     //                         style: TextStyle(
//     //                           fontSize: _height * 0.03,
//     //                         ),
//     //                         scrollPhysics: BouncingScrollPhysics(
//     //                             parent: AlwaysScrollableScrollPhysics()),
//     //                       ),
//     //                     ),
//     //                   ),
//     //                   Padding(
//     //                     padding: EdgeInsets.symmetric(
//     //                         horizontal: _width * 0.04,
//     //                         vertical: _height * 0.02),
//     //                     child: Container(
//     //                       child: Row(
//     //                         mainAxisAlignment: MainAxisAlignment.center,
//     //                         crossAxisAlignment: CrossAxisAlignment.center,
//     //                         children: [
//     //                           Image(
//     //                             image: NetworkImage(
//     //                                 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKsNkKv27ar4oDxu3aahsgl_1-cB_zHD-enw&usqp=CAU'),
//     //                           ),
//     //                         ],
//     //                       ),
//     //                     ),
//     //                   ),
//     //                   if (onVerifyClick &&
//     //                       !noMatchFound &&
//     //                       !noResultFound &&
//     //                       !isEaster)
//     //                     Container(
//     //                       padding: EdgeInsets.only(bottom: _height * 0.05),
//     //                       child: Row(
//     //                         mainAxisAlignment: MainAxisAlignment.center,
//     //                         children: [
//     //                           verifyText(
//     //                               isFake: false,
//     //                               percentage: (percentage != 0
//     //                                       ? 100 -
//     //                                           (_animation.value * percentage)
//     //                                       : _animation.value * 100)
//     //                                   .toInt()
//     //                                   .toString()),
//     //                           SizedBox(
//     //                             width: _width * 0.15,
//     //                           ),
//     //                           verifyText(
//     //                               isFake: true,
//     //                               percentage: (percentage != 0
//     //                                       ? _animation.value * percentage
//     //                                       : (100 - _animation.value * 100))
//     //                                   .toInt()
//     //                                   .toString()),
//     //                         ],
//     //                       ),
//     //                     ),
//     //                   if (noMatchFound ||
//     //                       noResultFound ||
//     //                       isEaster ||
//     //                       !hasInternet)
//     //                     Container(
//     //                       padding: EdgeInsets.only(
//     //                           bottom: _height * 0.05,
//     //                           left: _width * 0.05,
//     //                           right: _width * 0.05),
//     //                       child: Text(
//     //                         message,
//     //                         textAlign: TextAlign.center,
//     //                         style: TextStyle(
//     //                           color: Colors.black87,
//     //                         ),
//     //                       ),
//     //                     ),
//     //                   Container(
//     //                     width: _width * 0.55,
//     //                     height: _height * 0.09,
//     //                     child: FlatButton(
//     //                       shape: RoundedRectangleBorder(
//     //                         borderRadius: BorderRadius.circular(15.0),
//     //                       ),
//     //                       onPressed: () {
//     //                         if (_controller.text != null)
//     //                           _handleSubmitted(_controller.text);
//     //                       },
//     //                       color: Color(0xff48FD85),
//     //                       child: Text(
//     //                         'VERIFY',
//     //                         style: TextStyle(
//     //                             fontSize: _height * 0.03, color: Colors.white),
//     //                       ),
//     //                     ),
//     //                   ),
//     //                   if (onVerifyClick &&
//     //                       !noResultFound &&
//     //                       !isEaster &&
//     //                       Analyzer.descriptionToSend != null &&
//     //                       Analyzer.imageLinkToSend != null &&
//     //                       Analyzer.titleToSend != null &&
//     //                       Analyzer.formattedUrlToSend != null)
//     //                     Container(
//     //                       margin: EdgeInsets.only(top: _height * 0.05),
//     //                       child: GestureDetector(
//     //                         onTap: () {
//     //                           showModalBottomSheet(
//     //                             context: context,
//     //                             isScrollControlled: true,
//     //                             elevation: 10,
//     //                             enableDrag: true,
//     //                             builder: (context) => SingleChildScrollView(
//     //                               child: BottomSheetBuilder(
//     //                                 imageLink: Analyzer.imageLinkToSend,
//     //                                 siteName: Analyzer.siteNameToSend,
//     //                                 snippet: Analyzer.descriptionToSend,
//     //                                 title: Analyzer.titleToSend,
//     //                                 url: Analyzer.formattedUrlToSend,
//     //                               ),
//     //                             ),
//     //                           );
//     //                         },
//     //                         child: Text(
//     //                           'View Page',
//     //                           style: TextStyle(
//     //                               fontSize: _height * 0.028,
//     //                               color: Color(0xffff841b),
//     //                               decoration: TextDecoration.underline),
//     //                         ),
//     //                       ),
//     //                     ),
//     //                 ],
//     //               ),
//     //             ),
//     //           ),
//     //           if (isVisible)
//     //             Opacity(
//     //               opacity: 0.60,
//     //               child: Container(
//     //                 color: Colors.grey[100],
//     //                 height: _height,
//     //                 width: _width,
//     //               ),
//     //             ),
//     //           if (isVisible)
//     //             Center(
//     //               child: const SpinKitThreeBounce(
//     //                 color: Colors.blue,
//     //                 size: 20.0,
//     //               ),
//     //             ),
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
// }
