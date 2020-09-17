import 'dart:convert';

import 'package:fake_news_detector/Utilities/Networking.dart';

class Analyzer {
  Networking obj = Networking();
  query(String q) async {
    var joinedStrings = await obj.getData(q);
    List joinedList = joinedStrings
        .toString()
        .split('%*!@#Debuggers will beat everyone%*!@#');
    var decodeJson1 = jsonDecode(joinedList[0]);
    var decodeJson2 = jsonDecode(joinedList[1]);
    List snip = [];
    List title = [];
    List link = [];
    List url = [];

    for (int i = 0; i < 9; i++) {
      snip.add(decodeJson1['items'][i]['snippet']);
      snip.add(decodeJson2['items'][i]['snippet']);
      title.add(decodeJson1['items'][i]['title']);
      title.add(decodeJson2['items'][i]['title']);
      link.add(decodeJson1['items'][i]['displayLink']);
      link.add(decodeJson2['items'][i]['displayLink']);
      url.add(decodeJson1['items'][i]['formattedUrl']);
      url.add(decodeJson2['items'][i]['formattedUrl']);
    }
    print(snip);
  }
}
