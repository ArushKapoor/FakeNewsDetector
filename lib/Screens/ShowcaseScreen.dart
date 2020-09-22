import 'package:flutter/material.dart';

class ShowcaseScreen extends StatefulWidget {
  static const String id = 'showcase_screen';
  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(_width * 0.05),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15.0)),
          height: _height * 0.35,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  'https://factcheck.afp.com/sites/default/files/styles/twitter_card/public/medias/factchecking/india/factcheck-visual_14.png?itok=-C0YJAQw',
                  width: _width * 0.9,
                  height: _height * 0.22,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('1.'),
                  SizedBox(width: _width * 0.02),
                  Text('Times of India'),
                ],
              ),
              Text(
                'Unesco declares pm modi best of india',
                style: TextStyle(
                    fontSize: _height * 0.035, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
