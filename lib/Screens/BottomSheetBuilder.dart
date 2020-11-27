import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetBuilder extends StatelessWidget {
  BottomSheetBuilder(
      {this.title, this.imageLink, this.siteName, this.snippet, this.url});
  final String title, snippet, url, siteName, imageLink;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      color: Color(0xff000000),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: _width * 0.13,
              height: _height * 0.008,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(
              height: _height * 0.01,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: _height * 0.030,
              ),
            ),
            SizedBox(
              height: _height * 0.04,
            ),
            Text(
              snippet,
              style: TextStyle(fontSize: _height * 0.022, color: Colors.grey),
            ),
            SizedBox(
              height: _height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Card(
                      elevation: 2,
                      child: InkWell(
                        onTap: () async {
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch ';
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(_width * 0.01),
                          child: Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'News',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: _height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('Source - ' + siteName,
                      style: TextStyle(
                        fontSize: 15,
                      )),
                ),
              ],
            ),
            SizedBox(height: _height * 0.02),
            Image.network(
              imageLink,
              height: _height * 0.25,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
