import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchSheetBuilder extends StatefulWidget {
  SearchSheetBuilder();

  @override
  _SearchSheetBuilderState createState() => _SearchSheetBuilderState();
}

class _SearchSheetBuilderState extends State<SearchSheetBuilder> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    int numLines = 0;
    return
        // Container(
        // margin: EdgeInsets.only(
        //     bottom: _height * 0.85, left: _width * 0.05, right: _width * 0.05),
        // width: _width,
        // height: _height * 0.07,
        // padding: EdgeInsets.only(bottom: _height * 0.034),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15.0),
        //   color: Colors.white,
        // ),
        //     Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(15.0),
        //     color: Colors.white,
        //   ),
        //   margin: EdgeInsets.only(
        //       bottom: (_height * 0.84 - (numLines * 20)),
        //       left: _width * 0.05,
        //       right: _width * 0.05),
        //   child: ConstrainedBox(
        //     constraints: BoxConstraints(
        //       minHeight: _height * 0.08,
        //       maxHeight: _height * 0.3,
        //     ),
        //     child: TextFormField(
        //       maxLines: null,
        //       scrollPhysics: BouncingScrollPhysics(
        //         parent: AlwaysScrollableScrollPhysics(),
        //       ),
        //       keyboardType: TextInputType.multiline,
        //       showCursor: true,
        //       autofocus: true,
        //       cursorHeight: _height * 0.04,
        //       onChanged: (String e) {
        //         setState(() {
        //           numLines = '\n'.allMatches(e).length + 1;
        //         });
        //         print(numLines);
        //       },
        //       decoration: InputDecoration(
        //         border: InputBorder.none,
        //         contentPadding: EdgeInsets.symmetric(horizontal: _width * 0.03),
        //       ),
        //     ),
        //   ),
        // );

        Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,
          ),
          margin: EdgeInsets.only(
              // bottom: (_height * 0.84 - (numLines * 20)),
              left: _width * 0.05,
              right: _width * 0.05),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _height * 0.08,
              maxHeight: _height * 0.3,
            ),
            child: TextFormField(
              maxLines: null,
              scrollPhysics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              keyboardType: TextInputType.multiline,
              showCursor: true,
              autofocus: true,
              cursorHeight: _height * 0.04,
              onChanged: (String e) {
                setState(() {
                  numLines = '\n'.allMatches(e).length + 1;
                });
                print(numLines);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: _width * 0.03),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          // height: (numLines * 20).toDouble(),
          // width: (numLines * 20).toDouble(),
          height: 100,
          width: 100,
          child: Center(child: Text('$numLines')),
        ),
      ],
    );
  }
}
