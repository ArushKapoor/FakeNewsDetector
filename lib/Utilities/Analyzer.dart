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
    String wordset = 'fake hoax rumour fabricated';
    // snip.add(decodeJson1['items'][0]['snippet']);
    Rake rake = Rake();
    // for (int i = 0; i < 10; i++) {
    //   String word = decodeJson2['items'][i]['snippet'];
    //   double percentage = wordFrequencySimilarity(
    //       rake.rank(word.toString()).toString(), rake.rank(q).toString());
    //   print('$i     $percentage');
    // }
    //
    // // >= 0.30
    // for (int i = 0; i < 10; i++) {
    //   String word = decodeJson2['items'][i]['snippet'];
    //   print('$i    ${rake.rank(word.toString())}');
    //   print('');
    // }

    // for (int i = 0; i < 10; i++) {
    //   String word = decodeJson2['items'][i]['title'];
    //   double percentage = wordFrequencySimilarity(
    //       rake.rank(word.toString()).toString(), rake.rank(q).toString());
    //   print('$i     $percentage');
    // }
    //
    // // >= 0.35  DOUBT
    // for (int i = 0; i < 10; i++) {
    //   String word = decodeJson2['items'][i]['title'];
    //   print('$i    ${rake.rank(word.toString())}');
    //   print('');
    // }

    // Display Link not required

    for (int i = 0; i < 10; i++) {
      String word = decodeJson1['items'][i]['formattedUrl'];
      double percentage = wordFrequencySimilarity(
          rake.rank(word.toString()).toString(), rake.rank(q).toString());
      print('$i     $percentage');
    }

    // >= 0.30
    for (int i = 0; i < 10; i++) {
      String word = decodeJson1['items'][i]['formattedUrl'];
      print('$i    ${rake.rank(word.toString())}');
      print('');
    }

    // for (int i = 0; i < 10; i++) {
    //   snip.add(decodeJson1['items'][i]['snippet']);
    //   snip.add(decodeJson2['items'][i]['snippet']);
    //   title.add(decodeJson1['items'][i]['title']);
    //   title.add(decodeJson2['items'][i]['title']);
    //   link.add(decodeJson1['items'][i]['displayLink']);
    //   link.add(decodeJson2['items'][i]['displayLink']);
    //   url.add(decodeJson1['items'][i]['formattedUrl']);
    //   url.add(decodeJson2['items'][i]['formattedUrl']);
    // }
    // Rake rake = Rake();
    // print('This is rake : ');
    // print(rake.rank(
    //     snip.join(" ") + title.join(" ") + link.join(" ") + url.join(" ")));
    // // print(wordFrequencySimilarity(
    // //     rake
    // //         .rank(snip.join(" ") +
    // //             title.join(" ") +
    // //             link.join(" ") +
    // //             url.join(" "))
    // //         .toString(),
    // //     wordset));
    // int percentage = (wordFrequencySimilarity(
    //             rake
    //                 .rank(snip.join(" ") +
    //                     title.join(" ") +
    //                     link.join(" ") +
    //                     url.join(" "))
    //                 .toString(),
    //             wordset) *
    //         100)
    //     .toInt();
    // return percentage;
    return 0;
  }
}
