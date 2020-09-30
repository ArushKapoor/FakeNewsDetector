import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_news_detector/Screens/NewsScreen.dart';
import 'package:fake_news_detector/Utilities/Analyzer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppBody extends StatefulWidget {
  static const String id = 'news_tracking_screen';
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> with TickerProviderStateMixin {
  final _firestore = FirebaseFirestore.instance;
  TextEditingController _controller;
  AnimationController _animationController;
  Animation _animation;
  bool onVerifyClick = false;
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.slowMiddle);
  }

  int percent = 0;
  int percentage = 0;
  bool isAlreadyANews = false;
  bool noMatchFound = false;
  bool noResultFound = false;
  String message;
  String viewPage = '';
  void _handleSubmitted(String text) async {
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
        viewPage = '\nClick on view page for more details';
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
      print(percentage);
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

      _animationController.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    Column verifyText({bool isFake, String percentage}) {
      String text;
      Color textColor;
      if (isFake) {
        text = 'Incorrect';
        textColor = Colors.red;
      } else {
        text = 'Correct';
        textColor = Colors.green;
      }

      return Column(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: _height * 0.03, color: textColor),
          ),
          SizedBox(
            height: _height * 0.015,
          ),
          Text(
            percentage,
            style: TextStyle(fontSize: _height * 0.03, color: textColor),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Fake News Detector'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                          color: Colors.black,
                          width: 0.4,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      width: _width * 0.7,
                      height: _height * 0.5,
                      child: TextField(
                        maxLines: 200,
                        textAlignVertical: TextAlignVertical.bottom,
                        enableInteractiveSelection: true,
                        controller: _controller,
                        keyboardType: TextInputType.multiline,
                        scrollController: ScrollController(),
                        showCursor: true,
                        decoration: InputDecoration.collapsed(
                            fillColor: Color(0xff0000),
                            border: InputBorder.none,
                            hintText: 'Enter your query here',
                            hintStyle: TextStyle(fontSize: _height * 0.03)),
                        style: TextStyle(
                          fontSize: _height * 0.03,
                        ),
                        scrollPhysics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.05,
                    ),
                    if (onVerifyClick && !noMatchFound && !noResultFound)
                      Container(
                        padding: EdgeInsets.only(bottom: _height * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            verifyText(
                                isFake: true,
                                percentage: (percentage != 0
                                        ? _animation.value * percentage
                                        : (100 - _animation.value * 100))
                                    .toInt()
                                    .toString()),
                            SizedBox(
                              width: _width * 0.15,
                            ),
                            verifyText(
                                isFake: false,
                                percentage: (percentage != 0
                                        ? 100 - (_animation.value * percentage)
                                        : _animation.value * 100)
                                    .toInt()
                                    .toString()),
                          ],
                        ),
                      ),
                    if (noMatchFound || noResultFound)
                      Container(
                        padding: EdgeInsets.only(
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
                      width: _width * 0.55,
                      height: _height * 0.09,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        onPressed: () {
                          if (_controller.text != null)
                            _handleSubmitted(_controller.text);
                        },
                        color: Color(0xffff841b),
                        child: Text(
                          'VERIFY',
                          style: TextStyle(
                              fontSize: _height * 0.03, color: Colors.white),
                        ),
                      ),
                    ),
                    if (onVerifyClick &&
                        !noResultFound &&
                        Analyzer.descriptionToSend != null &&
                        Analyzer.imageLinkToSend != null &&
                        Analyzer.titleToSend != null &&
                        Analyzer.formattedUrlToSend != null)
                      Container(
                        margin: EdgeInsets.only(top: _height * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              NewsScreen.id,
                              arguments: ScreenArguments(
                                imageLink: Analyzer.imageLinkToSend,
                                siteName: Analyzer.siteNameToSend,
                                snippet: Analyzer.descriptionToSend,
                                title: Analyzer.titleToSend,
                                url: Analyzer.formattedUrlToSend,
                              ),
                            );
                          },
                          child: Text(
                            'View Page',
                            style: TextStyle(
                                fontSize: _height * 0.028,
                                color: Color(0xffff841b),
                                decoration: TextDecoration.underline),
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
    );
  }
}

class ScreenArguments {
  final String title;
  final String siteName;
  final String imageLink;
  final String snippet;
  final String url;
  ScreenArguments(
      {this.title, this.siteName, this.imageLink, this.snippet, this.url});
}
