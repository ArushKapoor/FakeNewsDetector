import 'dart:convert';
import 'package:fake_news_detector/Utilities/Networking.dart';
import 'package:rake/rake.dart';
import 'package:document_analysis/document_analysis.dart';

class Analyzer {
  static String titleToSend;
  static String imageLinkToSend;
  static String siteNameToSend;
  static String snippetToSend;
  Networking obj = Networking();
  Future query(String q) async {
    Rake rake = Rake();
    q = rake.rank(q).join(' ');
    q = q.replaceAll('-', ' ');
    q = q.replaceAll(',', ' ');
    q = q.replaceAll('/', ' ');
    q = q.replaceAll(':', ' ');
    q = q.replaceAll('.', ' ');
    q = q.replaceAll('_', ' ');

    var joinedStrings = await obj.getData(q);
    List joinedList = joinedStrings
        .toString()
        .split('%*!@#Debuggers will beat everyone%*!@#');
    var decodeJson1 = json.decode(joinedList[0]);

    titleToSend = decodeJson1['items'][1]['title'];
    snippetToSend = decodeJson1['items'][1]['snippet'];

    try {
      imageLinkToSend =
          decodeJson1['items'][1]['pagemap']['metatags'][0]['og:image'];
      siteNameToSend =
          decodeJson1['items'][1]['pagemap']['metatags'][0]['og:site_name'];
    } catch (e) {}
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

    print(wordFrequencySimilarity(
        rake
            .rank(snip.join(" ") +
                title.join(" ") +
                link.join(" ") +
                url.join(" "))
            .join(' '),
        wordset));
    // print(tfIdfSimilarity(
    //     rake
    //         .rank(snip.join(" ") +
    //             title.join(" ") +
    //             link.join(" ") +
    //             url.join(" "))
    //         .toString(),
    //     wordset,
    //     smartEnglish));
    // print(wordFrequencyProbability(documentTokenizer(snip)));
    // print(tfIdfProbability(documentTokenizer(snip)));
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
