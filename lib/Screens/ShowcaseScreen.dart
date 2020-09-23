import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_news_detector/Screens/MainScreen.dart';
import 'package:flutter/material.dart';

class ShowcaseScreen extends StatefulWidget {
  static const String id = 'showcase_screen';
  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    int newsNumber = 0;

    Column singleNews(
        {String title, String siteName, String imageLink, String snippet}) {
      newsNumber++;
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              '$newsNumber. $title',
              style: TextStyle(
                  fontSize: _height * 0.035, fontWeight: FontWeight.bold),
            ),
          SizedBox(
            height: _height * 0.02,
          ),
          if (siteName != null) Text(siteName),
          if (siteName != null)
            SizedBox(
              height: _height * 0.0,
            ),
          if (imageLink != null)
            Image.network(
              imageLink,
              height: _height * 0.3,
            ),
          if (imageLink != null)
            SizedBox(
              height: _height * 0.01,
            ),
          if (snippet != null)
            Text(
              snippet,
              style: TextStyle(fontSize: _height * 0.026),
            ),
          SizedBox(
            height: _height * 0.05,
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Fake News Detector'),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: _height * 0.87,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(_width * 0.05),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Padding(
                      padding: EdgeInsets.all(_width * 0.03),
                      child: Column(
                        children: [
                          singleNews(
                              title:
                                  '2016: Top 10 Fake News Forwards That We (Almost) Believed ...,',
                              siteName:
                                  'IndiaSpend-Journalism India |Data Journalism India|Investigative Journalism-IndiaSpend',
                              imageLink:
                                  'https://archive.indiaspend.com/wp-content/uploads/fake_960.jpeg',
                              snippet:
                                  'Dec 26, 2016 ... 1. UNESCO declares PM Modi best Prime Minister. UNESCO has been one of the primary alleged sources of fake news in India. In June 2016 ...'),
                          singleNews(
                              title:
                                  '2016: Top 10 Fake News Forwards That We (Almost) Believed ...,',
                              siteName:
                                  'IndiaSpend-Journalism India |Data Journalism India|Investigative Journalism-IndiaSpend',
                              imageLink:
                                  'https://archive.indiaspend.com/wp-content/uploads/fake_960.jpeg',
                              snippet:
                                  'Dec 26, 2016 ... 1. UNESCO declares PM Modi best Prime Minister. UNESCO has been one of the primary alleged sources of fake news in India. In June 2016 ...'),
                        ],
                      ),
                    ),
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

// NewsStream(firestore: _firestore, height: _height, width: _width),
class NewsStream extends StatelessWidget {
  const NewsStream({
    Key key,
    @required FirebaseFirestore firestore,
    @required double height,
    @required double width,
  })  : _firestore = firestore,
        _height = height,
        _width = width,
        super(key: key);

  final FirebaseFirestore _firestore;
  final double _height;
  final double _width;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('news').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final news = snapshot.data.docs;
        List<NewsTile> tiles = [];
        for (var newNews in news) {
          final imageUrl = newNews.get('img');
          final siteName = newNews.get('sitename');
          final snippet = newNews.get('snippet');
          final title = newNews.get('title');
          final newTile = NewsTile(
            height: _height,
            width: _width,
            imageUrl: imageUrl,
            siteName: siteName,
            title: title,
          );
          tiles.add(newTile);
          print(imageUrl);
          print(siteName);
          print(snippet);
          print(title);
        }
        print(tiles.length);
        return ListView(
          children: tiles,
        );
      },
    );
  }
}

class NewsTile extends StatelessWidget {
  NewsTile(
      {this.height,
      this.width,
      this.imageUrl,
      this.siteName,
      this.snippet,
      this.title});

  final double width;
  final double height;
  final String imageUrl;
  final String siteName;
  final String snippet;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0)),
          height: height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  imageUrl,
                  width: width * 0.9,
                  height: height * 0.22,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('1.'),
                  SizedBox(width: width * 0.02),
                  Text(siteName),
                ],
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: height * 0.035, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}
