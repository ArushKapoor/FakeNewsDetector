import 'dart:convert';
import 'package:fake_news_detector/Utilities/Networking.dart';
import 'package:rake/rake.dart';
import 'package:document_analysis/document_analysis.dart';

class Analyzer {
  static String titleToSend;
  static String imageLinkToSend;
  static String siteNameToSend;
  // static String snippetToSend;
  static String descriptionToSend;
  static String formattedUrlToSend;
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
    // List joinedList = joinedStrings
    //     .toString()
    //     .split('%*!@#Debuggers will beat everyone%*!@#');
    var decodeJson1 = json.decode(joinedStrings /*joinedList[0]*/);
    // titleToSend = decodeJson1['items'][1]['title'];
    // snippetToSend = decodeJson1['items'][1]['snippet'];
    // try {
    //   imageLinkToSend =
    //       decodeJson1['items'][1]['pagemap']['metatags'][0]['og:image'];
    //   siteNameToSend =
    //       decodeJson1['items'][1]['pagemap']['metatags'][0]['og:site_name'];
    // } catch (e) {
    //   print(e);
    // }
    List<String> wordSet = [
      'falsehood',
      'lie',
      'forgery',
      'fraud',
      'phoney',
      'pirate',
      'false',
      'pseudo',
      'fakey',
      'cheat',
      'bluff',
      'fake',
      'viral',
      'hoax',
      'rumour'
    ];

    int totalMatched = 0;
    int fakeMatched = 0;
    int percentage = 0;
    bool isFakeChecked = false;
    bool isTrueChecked = false;
    int posForTrue = 0;
    for (int i = 0; i < 10; i++) {
      String wordSnip, wordTitle, wordUrl;

      wordSnip = decodeJson1['items'][i]['snippet'];
      wordTitle = decodeJson1['items'][i]['title'];
      wordUrl = decodeJson1['items'][i]['formattedUrl'];

      // else {
      //   wordSnip = decodeJson2['items'][i - 10]['snippet'];
      //   wordTitle = decodeJson2['items'][i - 10]['title'];
      //   wordUrl = decodeJson2['items'][i - 10]['formattedUrl'];
      // }
      String rakeWordSnip = rake.rank(wordSnip).join(' ');
      double ratioSnip =
          wordFrequencySimilarity(rakeWordSnip, rake.rank(q).join(''));

      String rakeWordTitle = rake.rank(wordTitle).join('');
      double ratioTitle =
          wordFrequencySimilarity(rakeWordTitle, rake.rank(q).join(''));

      wordUrl = wordUrl.replaceAll('-', ' ');
      wordUrl = wordUrl.replaceAll(',', ' ');
      wordUrl = wordUrl.replaceAll('/', ' ');
      wordUrl = wordUrl.replaceAll(':', ' ');
      wordUrl = wordUrl.replaceAll('.', ' ');
      wordUrl = wordUrl.replaceAll('_', ' ');

      if (ratioSnip >= 0.30 || ratioTitle >= 0.35) {
        print('Ratios are for $i : $ratioSnip and $ratioTitle');
        print('Rake for $i are : $rakeWordSnip and $rakeWordTitle');
        print('');
        totalMatched++;
        int checkFakeMatched = fakeMatched;

        for (int i = 0; i < wordSet.length; i++) {
          if (rakeWordSnip.contains(wordSet[i]) ||
              rakeWordTitle.contains(wordSet[i]) ||
              wordUrl.contains(wordSet[i])) {
            if (!isFakeChecked) {
              descriptionToSend = decodeJson1['items'][i]['pagemap']['metatags']
                  [0]['og: description'];
              imageLinkToSend =
                  decodeJson1['items'][i]['pagemap']['metatags'][0]['og:image'];
              siteNameToSend = decodeJson1['items'][i]['pagemap']['metatags'][0]
                  ['og:site_name'];
              if (imageLinkToSend != null &&
                  siteNameToSend != null &&
                  descriptionToSend != null) {
                titleToSend = decodeJson1['items'][i]['title'];
                formattedUrlToSend = decodeJson1['items'][i]['formattedUrl'];
                // snippetToSend = decodeJson1['items'][i]['snippet'];
                isFakeChecked = true;
              }
            }
            fakeMatched++;
            break;
          }
        }
        if (checkFakeMatched != fakeMatched) {
          if (!isTrueChecked) {
            String descriptionToSend = decodeJson1['items'][i]['pagemap']
                ['metatags'][0]['og: description'];
            String imageLinkToSend =
                decodeJson1['items'][i]['pagemap']['metatags'][0]['og:image'];
            String siteNameToSend = decodeJson1['items'][i]['pagemap']
                ['metatags'][0]['og:site_name'];
            if (imageLinkToSend != null &&
                siteNameToSend != null &&
                descriptionToSend != null) {
              posForTrue = i;
              isTrueChecked = true;
            }
          }
        }
      }
      print('$i     $percentage');
    }

    percentage =
        ((fakeMatched.toDouble() / totalMatched.toDouble()) * 100.0).toInt();

    if (percentage < 50) {
      descriptionToSend = decodeJson1['items'][posForTrue]['pagemap']
          ['metatags'][0]['og: description'];
      imageLinkToSend = decodeJson1['items'][posForTrue]['pagemap']['metatags']
          [0]['og:image'];
      siteNameToSend = decodeJson1['items'][posForTrue]['pagemap']['metatags']
          [0]['og:site_name'];
      titleToSend = decodeJson1['items'][posForTrue]['title'];
      formattedUrlToSend = decodeJson1['items'][posForTrue]['formattedUrl'];
      // snippetToSend = decodeJson1['items'][posForTrue]['snippet'];
    }

    // Display Link not required

    // Formatted url only to check fake

    return percentage;
  }
}
