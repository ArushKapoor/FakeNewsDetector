import 'package:fake_news_detector/Screens/MainScreen.dart';
import 'package:flutter/material.dart';

class ShowcaseScreen extends StatefulWidget {
  static const String id = 'showcase_screen';
  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Fake News Detector'),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(_width * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15.0)),
                  height: _height,
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          'https://factcheck.afp.com/sites/default/files/styles/twitter_card/public/medias/factchecking/india/factcheck-visual_14.png?itok=-C0YJAQw',
                          width: _width * 0.9,
                          height: _height * 0.22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('1.'),
                          SizedBox(width: _width * 0.02),
                          Text('Times of India'),
                        ],
                      ),
                      Text(
                        'Unesco declares pm modi best of india',
                        style: TextStyle(
                            fontSize: _height * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Image.network(
                          'https://factcheck.afp.com/sites/default/files/styles/twitter_card/public/medias/factchecking/india/factcheck-visual_14.png?itok=-C0YJAQw',
                          width: _width * 0.9,
                          height: _height * 0.22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('1.'),
                          SizedBox(width: _width * 0.02),
                          Text('Times of India'),
                        ],
                      ),
                      Text(
                        'Unesco declares pm modi best of india',
                        style: TextStyle(
                            fontSize: _height * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Image.network(
                          'https://factcheck.afp.com/sites/default/files/styles/twitter_card/public/medias/factchecking/india/factcheck-visual_14.png?itok=-C0YJAQw',
                          width: _width * 0.9,
                          height: _height * 0.22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('1.'),
                          SizedBox(width: _width * 0.02),
                          Text('Times of India'),
                        ],
                      ),
                      Text(
                        'Unesco declares pm modi best of india',
                        style: TextStyle(
                            fontSize: _height * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Image.network(
                          'https://factcheck.afp.com/sites/default/files/styles/twitter_card/public/medias/factchecking/india/factcheck-visual_14.png?itok=-C0YJAQw',
                          width: _width * 0.9,
                          height: _height * 0.22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('1.'),
                          SizedBox(width: _width * 0.02),
                          Text('Times of India'),
                        ],
                      ),
                      Text(
                        'Unesco declares pm modi best of india',
                        style: TextStyle(
                            fontSize: _height * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Image.network(
                          'https://factcheck.afp.com/sites/default/files/styles/twitter_card/public/medias/factchecking/india/factcheck-visual_14.png?itok=-C0YJAQw',
                          width: _width * 0.9,
                          height: _height * 0.22,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('1.'),
                          SizedBox(width: _width * 0.02),
                          Text('Times of India'),
                        ],
                      ),
                      Text(
                        'Unesco declares pm modi best of india',
                        style: TextStyle(
                            fontSize: _height * 0.035,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                color: Colors.white,
                width: _width,
                height: _height * 0.13,
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: _width * 0.55,
                  height: _height * 0.09,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppBody.id);
                    },
                    color: Colors.pink,
                    child: Text(
                      'VERIFY',
                      style: TextStyle(
                          fontSize: _height * 0.03, color: Colors.white),
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
