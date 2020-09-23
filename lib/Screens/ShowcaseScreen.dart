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
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        primary: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              Navigator.pushNamed(context, AppBody.id);
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _height * 0.9,
          child: StreamBuilder<QuerySnapshot>(
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
          ),
        ),
      ),
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
            color: Colors.grey[200], borderRadius: BorderRadius.circular(15.0)),
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
      ),
    );
  }
}
