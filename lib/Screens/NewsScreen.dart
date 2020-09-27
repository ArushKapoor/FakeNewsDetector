import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatelessWidget {
  static const String id = 'news_screen';
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    //print(args.title);

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    //final link = LinkableElement('My Url', 'https://cretezy.com');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Corner',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(_width * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (args.title != null)
                  Text(
                    args.title,
                    style: TextStyle(
                      fontSize: _height * 0.034,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(
                  height: _height * 0.011,
                ),
                if (args.siteName != null) Text(args.siteName),
                if (args.siteName != null)
                  SizedBox(
                    height: _height * 0.00,
                  ),
                if (args.imageLink != null)
                  Image.network(
                    args.imageLink,
                    height: _height * 0.3,
                    fit: BoxFit.fill,
                  ),
                if (args.imageLink != null)
                  SizedBox(
                    height: _height * 0.0,
                  ),
                if (args.snippet != null)
                  Text(
                    args.snippet,
                    style: TextStyle(
                      fontSize: _height * 0.022,
                    ),
                  ),
                if (args.snippet != null)
                  SizedBox(
                    height: _height * 0.012,
                  ),
                if (args.url != null)
                  Container(
                    width: _width * 0.7,
                    child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      textWidthBasis: TextWidthBasis.parent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      text: "Check here : ${args.url}",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                      linkStyle: TextStyle(
                        color: Colors.blueAccent[200],
                        fontWeight: FontWeight.normal,
                      ),
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
