import 'package:fake_news_detector/Utilities/Networking.dart';

class Analyzer {
  Networking obj = Networking();
  query(String q) async {
    var decodeJson1 = await obj.getData(q);
    List snip;
    List title;
    List link;
    List url;

    for (int i = 0; i < 10; i++) {
      String snipString = decodeJson1['items'][i]['snippet'];
      snip.addAll(snipString.split(' '));
      String titleString = decodeJson1['items'][i]['title'];
      title.addAll(titleString.split(' '));
      String linkString = decodeJson1['items'][i]['displayLink'];
      link.addAll(linkString.split(' '));
      String urlString = decodeJson1['items'][i]['formattedUrl'];
      url.addAll(urlString.split(' '));
    }
  }
}
