import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_news_detector/Screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'BottomSheetBuilder.dart';

class ShowcaseScreen extends StatefulWidget {
  static const String id = 'showcase_screen';
  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  final _firestore = FirebaseFirestore.instance;
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
        wishClr = 0xffffffff;
        gradientTopContainer = 0xff1f6599;
        gradientBottomContainer = 0xffc7d1c9;
        gradientTopButton = 0xffb9c8c5;
        gradientBottomButton = 0xffc7d1c9;
      } else if (hour > 12 && hour < 17) {
        wish = 'Good Afternoon';
        imgSrc = 'assets/Images/Noon.jpeg';
        backClr = 0xff977c54;
        wishClr = 0xffffffff;
        gradientTopContainer = 0xff977c53;
        gradientBottomContainer = 0xffd4b29a;
        gradientTopButton = 0xffcdab91;
        gradientBottomButton = 0xffcdab91;
      } else if (hour > 17 && hour < 20) {
        wish = 'Good Evening';
        imgSrc = 'assets/Images/evening.jpeg';
        backClr = 0xff847fca;
        wishClr = 0xffffffff;
        gradientTopContainer = 0xff847fca;
        gradientBottomContainer = 0xffc294ae;
        gradientTopButton = 0xffba91b1;
        gradientBottomButton = 0xffc294ae;
      } else {
        wish = 'Good Night';
        imgSrc = 'assets/Images/night.jpeg';
        backClr = 0xff1f1e43;
        wishClr = 0xffffffff;
        gradientTopContainer = 0xff272445;
        gradientBottomContainer = 0xff5e5370;
        gradientTopButton = 0xff5e5370;
        gradientBottomButton = 0xff5e5370;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    timing();
  }

  @override
  Widget build(BuildContext context) {
    //imgSrc = 'assets/Images/night.jpeg';
    //backClr = 0xff181818;
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(backClr),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            NestedScrollView(
              physics: BouncingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    floating: false,
                    pinned: false,
                    snap: false,
                    backgroundColor: Colors.white10,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        children: [
                          Image(
                            image: AssetImage(imgSrc),
                            alignment: Alignment.center,
                            fit: BoxFit.fill,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                wish,
                                style: TextStyle(
                                    fontSize: _height * 0.04,
                                    color: Color(wishClr)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      stretchModes: [
                        StretchMode.fadeTitle,
                        StretchMode.zoomBackground,
                      ],
                    ),
                    stretch: true,
                    centerTitle: true,
                    expandedHeight: _height * 0.29,
                  ),
                ];
              },
              body: Container(
                //color: Color(0xffffffff),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                      Color(gradientTopContainer),
                      Color(gradientBottomContainer)
                    ])),
                height: _height * 0.87,
                child: NewsStream(
                    firestore: _firestore, height: _height, width: _width),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  width: _width,
                  height: _height * 0.08,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                        Color(gradientTopButton),
                        Color(gradientBottomButton),
                      ])),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        //borderRadius: BorderRadius.circular(15.0),
                        ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppBody.id);
                    },
                    // color: Color(backClr),
                    child: Text(
                      'VERIFY',
                      style: TextStyle(
                          fontSize: _height * 0.03, color: Color(wishClr)),
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
      stream: _firestore
          .collection('news')
          .orderBy('count', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          );
        }
        final news = snapshot.data.docs;
        int newsNumber = 1;
        List<Widget> tiles = [];
        for (var newNews in news) {
          final imageUrl = newNews.get('img');
          final siteName = newNews.get('sitename');
          final snippet = newNews.get('description');
          final title = newNews.get('title');
          final url = newNews.get('url');
          final newTile = SingleNewsTile(
            height: _height,
            imageLink: imageUrl,
            siteName: siteName,
            snippet: snippet,
            title: title,
            width: _width,
            newsNumber: newsNumber,
            url: url,
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
      this.newsNumber,
      this.url});
  final double width;
  final double height;
  final String imageLink;
  final String siteName;
  final String snippet;
  final String title;
  final int newsNumber;
  final String url;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      //elevation: 10,
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            elevation: 10,
            enableDrag: true,
            builder: (context) => SingleChildScrollView(
              child: BottomSheetBuilder(
                imageLink: imageLink,
                siteName: siteName,
                snippet: snippet,
                title: title,
                url: url,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Image(
              image: NetworkImage(imageLink),
              fit: BoxFit.fill,
              height: height * 0.2,
              width: width * 0.35,
            ),
            SizedBox(width: width * 0.02),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    softWrap: true,
                    maxLines: 4,
                    //textHeightBehavior: TextHeightBehavior.fromEncoded(4),
                    textWidthBasis: TextWidthBasis.parent,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: height * 0.025),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Blanck extends StatelessWidget {
  Blanck({this.height});
  final height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.1,
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

// GestureDetector(
// onTap: () {
//   Navigator.pushNamed(context, NewsScreen.id,
//       arguments: ScreenArguments(
//         imageLink: imageLink,
//         siteName: siteName,
//         snippet: snippet,
//         title: title,
//         url: url,
//       ));
// },
//       child: Container(
//         padding: EdgeInsets.all(15),
//         margin: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           color: Color(0xffffffff), //card color
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '$newsNumber. $title',
//               style: TextStyle(
//                   fontSize: height * 0.03,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xff000000)),
//             ),
//             SizedBox(
//               height: height * 0.005,
//             ),
//             Text(
//               siteName,
//               style: TextStyle(color: Color(0xff173f5f)),
//             ),
//             SizedBox(
//               height: height * 0.0,
//             ),
//             Image.network(
//               imageLink,
//               height: height * 0.24,
//               fit: BoxFit.fill,
//             ),
//             SizedBox(
//               height: height * 0.01,
//             ),
//             SizedBox(
//               height: height * 0.0,
//             ),
//           ],
//         ),
//       ),
//     );
