import 'package:flutter/material.dart';
import 'MainScreen.dart';
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
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.all(_width * 0.01),
                child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        'https://img.icons8.com/ultraviolet/40/000000/test-account.png')))
          ]),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(_width * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: _height * 0.06,
                      ),
                      if (args.title != null)
                        Text(
                          args.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: _height * 0.030,
                          ),
                        ),
                      SizedBox(
                        height: _height * 0.04,
                      ),
                      if (args.snippet != null)
                        Text(
                          args.snippet,
                          style: TextStyle(
                              fontSize: _height * 0.022, color: Colors.grey),
                        ),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    if (await canLaunch(args.url)) {
                                      await launch(args.url);
                                    } else {
                                      throw 'Could not launch $args';
                                    }
                                  },
                                  child: Card(
                                    elevation: 2,
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
                                  ))
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
                      if (args.siteName != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text('Source - ' + args.siteName,
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                            ),
                          ],
                        ),
                      SizedBox(height: _height * 0.02),
                      if (args.imageLink != null)
                        Image.network(
                          args.imageLink,
                          height: _height * 0.25,
                          fit: BoxFit.fill,
                        ),
                    ],
                  )))),

      // body: SafeArea(
      //   child: SingleChildScrollView(
      //     child: Padding(
      //       padding: EdgeInsets.all(_width * 0.03),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           if (args.title != null)
      //             Text(
      //               args.title,
      //               style: TextStyle(
      //                 fontSize: _height * 0.034,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             ),
      //           SizedBox(
      //             height: _height * 0.011,
      //           ),
      //           if (args.siteName != null) Text(args.siteName),
      //           if (args.siteName != null)
      //             SizedBox(
      //               height: _height * 0.00,
      //             ),
      //           if (args.imageLink != null)
      //             Image.network(
      //               args.imageLink,
      //               height: _height * 0.3,
      //               fit: BoxFit.fill,
      //             ),
      //           if (args.imageLink != null)
      //             SizedBox(
      //               height: _height * 0.0,
      //             ),
      //           if (args.snippet != null)
      //             Text(
      //               args.snippet,
      //               style: TextStyle(
      //                 fontSize: _height * 0.022,
      //               ),
      //             ),
      //           if (args.snippet != null)
      //             SizedBox(
      //               height: _height * 0.012,
      //             ),
      //           if (args.url != null)
      //             Container(
      //               width: _width * 0.7,
      //               child: Linkify(
      //                 onOpen: (link) async {
      //                   if (await canLaunch(link.url)) {
      //                     await launch(link.url);
      //                   } else {
      //                     throw 'Could not launch $link';
      //                   }
      //                 },
      //                 textWidthBasis: TextWidthBasis.parent,
      //                 maxLines: 1,
      //                 overflow: TextOverflow.ellipsis,
      //                 softWrap: true,
      //                 text: "Check here : ${args.url}",
      //                 style: TextStyle(
      //                     color: Colors.black54, fontWeight: FontWeight.bold),
      //                 linkStyle: TextStyle(
      //                   color: Colors.blueAccent[200],
      //                   fontWeight: FontWeight.normal,
      //                 ),
      //               ),
      //             ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
