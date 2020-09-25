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
  Color backGroundColor = Colors.white;
  Animation _animationRed;
  Animation _animationGreen;
  bool onVerifyClick = false;
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _animationController = AnimationController(
      duration: Duration(seconds: 7),
      vsync: this,
    );
    _animationRed = ColorTween(begin: Colors.white, end: Colors.red)
        .animate(_animationController);
    _animationGreen = ColorTween(begin: Colors.white, end: Colors.green)
        .animate(_animationController);
  }

  int percent = 0;
  int percentage = 0;
  bool isAlreadyANews = false;
  void _handleSubmitted(String text) async {
    if (text != null && text.isNotEmpty) {
      setState(() {
        isVisible = true;
        //onVerifyClick = false;
      });
      Analyzer networking = Analyzer();
      percent = await networking.query(text);
      //print(percent);
      percentage = percent;

      final newses = await _firestore.collection('news').get();
      for (var news in newses.docs) {
        if (news.data().containsValue(Analyzer.descriptionToSend) == true) {
          isAlreadyANews = true;
          break;
        }
      }
      if (isAlreadyANews == false &&
          Analyzer.descriptionToSend != null &&
          Analyzer.siteNameToSend != null &&
          Analyzer.imageLinkToSend != null &&
          Analyzer.titleToSend != null &&
          Analyzer.formattedUrlToSend != null) {
        _firestore.collection('news').add({
          // 'snippet': Analyzer.snippetToSend,
          'description': Analyzer.descriptionToSend,
          'sitename': Analyzer.siteNameToSend,
          'img': Analyzer.imageLinkToSend,
          'time': DateTime.now(),
          'title': Analyzer.titleToSend,
          'url': Analyzer.formattedUrlToSend,
        });
      }
      setState(() {
        percentage = percent;
        onVerifyClick = true;
        isVisible = false;
      });

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
      backgroundColor: backGroundColor,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        title: Text('Fake News Detector'),
        backgroundColor: Colors.pink,
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
                        decoration: InputDecoration.collapsed(
                            fillColor: Color(0xff0000),
                            border: InputBorder.none,
                            hintText: 'Enter text...',
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
                    if (onVerifyClick)
                      Container(
                        padding: EdgeInsets.only(bottom: _height * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            verifyText(
                                isFake: true,
                                percentage:
                                    (_animationController.value * percentage)
                                        .toInt()
                                        .toString()),
                            SizedBox(
                              width: _width * 0.15,
                            ),
                            verifyText(
                                isFake: false,
                                percentage: (100 -
                                        (_animationController.value *
                                            percentage))
                                    .toInt()
                                    .toString()),
                          ],
                        ),
                      ),
                    Container(
                      width: _width * 0.55,
                      height: _height * 0.09,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.red),
                        ),
                        onPressed: () {
                          if (_controller.text != null)
                            _handleSubmitted(_controller.text);
                        },
                        color: Colors.pink,
                        child: Text(
                          'VERIFY',
                          style: TextStyle(
                              fontSize: _height * 0.03, color: Colors.white),
                        ),
                      ),
                    ),
                    if (onVerifyClick)
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
                                color: Colors.grey,
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
