import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'MainScreen.dart';

class SearchSheetBuilder extends StatefulWidget {
  SearchSheetBuilder({this.initialText});
  final String initialText;

  @override
  _SearchSheetBuilderState createState() => _SearchSheetBuilderState();
}

class _SearchSheetBuilderState extends State<SearchSheetBuilder> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: _height * 0.08,
                  left: _width * 0.05,
                  right: _width * 0.05),
              // height: _height * 0.07,
              // width: _width,
              constraints: BoxConstraints(
                minHeight: _height * 0.08,
                minWidth: _width,
                maxHeight: _height * 0.4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: TextFormField(
                maxLines: null,
                scrollPhysics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                keyboardType: TextInputType.multiline,
                controller: AppBody.controller,
                showCursor: true,
                autofocus: true,
                cursorHeight: _height * 0.04,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: _width * 0.04, vertical: _height * 0.01),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    AppBody.controller = TextEditingController();
    if (widget.initialText != null) {
      AppBody.controller.text = widget.initialText;
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('${AppBody.controller.text}');
  }
}
