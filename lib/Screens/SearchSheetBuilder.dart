import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Column(children: [
      Container(
        height: _height * 0.5,
        color: Colors.white,
        child: TextFormField(
          maxLines: null,
          scrollPhysics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          keyboardType: TextInputType.multiline,
          showCursor: true,
          autofocus: true,
          cursorHeight: _height * 0.04,
          onChanged: (String value) {
            // setState(() {
            //   numLines = '\n'.allMatches(value).length + 1;
            // });
            // print(value);
            // print(numLines);
          },
        ),
      ),
    ]);

    //     Column(
    //   children: [
    //     Container(
    //       color: Colors.white,
    //       // height: (numLines * 20).toDouble(),
    //       // width: (numLines * 20).toDouble(),
    //       height: 100,
    //       width: 100,
    //       child: Center(child: Text('$numLines')),
    //     ),
    //     Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(15.0),
    //         color: Colors.white,
    //       ),
    //       margin: EdgeInsets.only(
    //           // bottom: (_height * 0.84 - (numLines * 20)),
    //           left: _width * 0.05,
    //           right: _width * 0.05),
    //       child: ConstrainedBox(
    //         constraints: BoxConstraints(
    //           minHeight: _height * 0.08,
    //           maxHeight: _height * 0.3,
    //         ),
    // child: TextFormField(
    //   maxLines: null,
    //   scrollPhysics: BouncingScrollPhysics(
    //     parent: AlwaysScrollableScrollPhysics(),
    //   ),
    //   keyboardType: TextInputType.multiline,
    //   showCursor: true,
    //   autofocus: true,
    //   cursorHeight: _height * 0.04,
    //   onChanged: (String value) {
    //     // setState(() {
    //     //   numLines = '\n'.allMatches(value).length + 1;
    //     // });
    //     // print(value);
    //     // print(numLines);
    //   },
    //   decoration: InputDecoration(
    //     border: InputBorder.none,
    //     contentPadding: EdgeInsets.symmetric(horizontal: _width * 0.03),
    //   ),
    // ),
    //       ),
    //     ),
    //     Container(
    //       color: Colors.white,
    //       // height: (numLines * 20).toDouble(),
    //       // width: (numLines * 20).toDouble(),
    //       height: 100,
    //       width: 100,
    //       child: Center(child: Text('$numLines')),
    //     ),
    //   ],
    // );
  }
}
