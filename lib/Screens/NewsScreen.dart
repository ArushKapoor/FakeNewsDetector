import 'package:flutter/material.dart';
import 'MainScreen.dart';

class NewsScreen extends StatelessWidget {
  static const String id = 'news_screen';
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    //print(args.title);

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        title: Text(
          'News Corner',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
