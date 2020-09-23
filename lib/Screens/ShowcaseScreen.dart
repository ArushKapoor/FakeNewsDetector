import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_news_detector/Screens/MainScreen.dart';
import 'package:fake_news_detector/Screens/NewsScreen.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Fake News Detector'),
        backgroundColor: Colors.pink,
        centerTitle: true,
        leading: null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: _width * 0.02,
                  bottom: _width * 0.05,
                  right: _width * 0.02,
                  top: _height * 0.01),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  height: _height * 0.87,
                  child: NewsStream(
                      firestore: _firestore, height: _height, width: _width),
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
        int newsNumber = 1;
        List<SingleNewsTile> tiles = [];
        for (var newNews in news) {
          final imageUrl = newNews.get('img');
          final siteName = newNews.get('sitename');
          final snippet = newNews.get('snippet');
          final title = newNews.get('title');
          final newTile = SingleNewsTile(
            height: _height,
            imageLink: imageUrl,
            siteName: siteName,
            snippet: snippet,
            title: title,
            width: _width,
            newsNumber: newsNumber,
          );
          tiles.add(newTile);
          newsNumber++;
        }
        return ListView(
          children: tiles,
        );
      },
    );
  }
}

class SingleNewsTile extends StatelessWidget {
  SingleNewsTile(
      {this.title,
      this.siteName,
      this.imageLink,
      this.snippet,
      this.height,
      this.width,
      this.newsNumber});
  final double width;
  final double height;
  final String imageLink;
  final String siteName;
  final String snippet;
  final String title;
  final int newsNumber;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, NewsScreen.id,
            arguments: ScreenArguments(
                imageLink: imageLink,
                siteName: siteName,
                snippet: snippet,
                title: title));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.greenAccent[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$newsNumber. $title',
              style: TextStyle(
                  fontSize: height * 0.035, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: height * 0.005,
            ),
            Text(siteName),
            SizedBox(
              height: height * 0.0,
            ),
            Image.network(
              imageLink,
              height: height * 0.24,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              height: height * 0.0,
            ),
          ],
        ),
      ),
    );
  }
}
// class NewsTile extends StatelessWidget {
//   NewsTile(
//       {this.height,
//       this.width,
//       this.imageUrl,
//       this.siteName,
//       this.snippet,
//       this.title});

//   final double width;
//   final double height;
//   final String imageUrl;
//   final String siteName;
//   final String snippet;
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(width * 0.05),
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.grey[200], borderRadius: BorderRadius.circular(15.0)),
//         height: height * 0.35,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Image.network(
//                 imageUrl,
//                 width: width * 0.9,
//                 height: height * 0.22,
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text('1.'),
//                 SizedBox(width: width * 0.02),
//                 Text(siteName),
//               ],
//             ),
//             Text(
//               title,
//               style: TextStyle(
//                   fontSize: height * 0.035, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
