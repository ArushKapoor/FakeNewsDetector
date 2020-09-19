import 'dart:convert';
import 'package:fake_news_detector/Utilities/Networking.dart';
import 'package:rake/rake.dart';
import 'package:document_analysis/document_analysis.dart';

class Analyzer {
  Networking obj = Networking();
  Future query(String q) async {
    var joinedStrings = await obj.getData(q);
    List joinedList = joinedStrings
        .toString()
        .split('%*!@#Debuggers will beat everyone%*!@#');
    var decodeJson1 = json.decode(joinedList[0]);
    var decodeJson2 = json.decode(joinedList[1]);
    List<String> snip = [];
    List<String> title = [];
    List<String> link = [];
    List<String> url = [];
    String wordset =
        'falsehood lie forgery fraud phoney pirate false pseudo fakey cheat bluff fake viral hoax rumour';
    for (int i = 0; i < 10; i++) {
      snip.add(decodeJson1['items'][i]['snippet']);
      snip.add(decodeJson2['items'][i]['snippet']);
      title.add(decodeJson1['items'][i]['title']);
      title.add(decodeJson2['items'][i]['title']);
      link.add(decodeJson1['items'][i]['displayLink']);
      link.add(decodeJson2['items'][i]['displayLink']);
      url.add(decodeJson1['items'][i]['formattedUrl']);
      url.add(decodeJson2['items'][i]['formattedUrl']);
    }
    Rake rake = Rake();
    // print(rake.rank(
    //     snip.join(" ") + title.join(" ") + link.join(" ") + url.join(" ")));
    print(wordFrequencySimilarity(
        rake
            .rank(snip.join(" ") +
                title.join(" ") +
                link.join(" ") +
                url.join(" "))
            .toString(),
        wordset));
    int percentage = (wordFrequencySimilarity(
                rake
                    .rank(snip.join(" ") +
                        title.join(" ") +
                        link.join(" ") +
                        url.join(" "))
                    .toString(),
                wordset) *
            100)
        .toInt();
    return percentage;
  }
}
