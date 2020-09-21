import 'package:flutter/material.dart';
import 'MainScreen.dart';

class NewsScreen extends StatelessWidget {
  static const String id = 'news_screen';
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    print(args.title);

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Corner',
          style: TextStyle(fontSize: _height * 0.03, color: Colors.blueAccent),
        ),
        centerTitle: true,
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: _width * 0.1,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(_width * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (args.title != null)
                  Text(
                    args.title,
                    style: TextStyle(
                        fontSize: _height * 0.035, fontWeight: FontWeight.bold),
                  ),
                SizedBox(
                  height: _height * 0.02,
                ),
                if (args.siteName != null) Text(args.siteName),
                if (args.siteName != null)
                  SizedBox(
                    height: _height * 0.0,
                  ),
                if (args.imageLink != null)
                  Image.network(
                    args.imageLink,
                    height: _height * 0.3,
                  ),
                if (args.imageLink != null)
                  SizedBox(
                    height: _height * 0.01,
                  ),
                if (args.snippet != null)
                  Text(
                    args.snippet,
                    style: TextStyle(fontSize: _height * 0.026),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
