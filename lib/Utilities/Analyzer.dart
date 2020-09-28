import 'dart:convert';
import 'package:fake_news_detector/Utilities/Networking.dart';
import 'package:rake/rake.dart';
import 'package:document_analysis/document_analysis.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:edit_distance/edit_distance.dart';

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
    q = q.replaceAll('-', ' ');
    q = q.replaceAll(',', ' ');
    q = q.replaceAll('/', ' ');
    q = q.replaceAll(':', ' ');
    q = q.replaceAll('.', ' ');
    q = q.replaceAll('_', ' ');

    titleToSend = null;
    imageLinkToSend = null;
    siteNameToSend = null;
    descriptionToSend = null;
    formattedUrlToSend = null;

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
      'rumour',
      'alleged'
    ];

    int totalMatched = 0;
    int fakeMatched = 0;
    int percentage = 0;
    bool isFakeChecked = false;
    bool isTrueChecked = false;
    int posForTrue = 0;
    int checkCount = 0;
    int searchResults =
        int.parse(decodeJson1['queries']['request'][0]['totalResults']);
    if (decodeJson1['spelling'] != null) {
      q = decodeJson1['spelling']['correctedQuery'];
    }
    if (searchResults > 10) searchResults = 10;
    for (int i = 0; i < searchResults; i++) {
      String wordSnip, wordTitle, wordUrl;

      wordSnip = decodeJson1['items'][i]['snippet'];
      wordTitle = decodeJson1['items'][i]['title'];
      wordUrl = decodeJson1['items'][i]['formattedUrl'];
      String rakeWordSnip = rake.rank(wordSnip).join(' ');
      double ratioRakeSnip =
          wordFrequencySimilarity(rakeWordSnip, rake.rank(q).join(' '));
      double ratioSnip = wordSnip.similarityTo(rake.rank(q).join(' '));

      String rakeWordTitle = rake.rank(wordTitle).join(' ');
      double ratioTitle =
          wordFrequencySimilarity(rakeWordTitle, rake.rank(q).join(' '));

      wordUrl = wordUrl.replaceAll('-', ' ');
      wordUrl = wordUrl.replaceAll(',', ' ');
      wordUrl = wordUrl.replaceAll('/', ' ');
      wordUrl = wordUrl.replaceAll(':', ' ');
      wordUrl = wordUrl.replaceAll('.', ' ');
      wordUrl = wordUrl.replaceAll('_', ' ');

      Levenshtein l = new Levenshtein();
      Jaccard j = new Jaccard();

      checkCount++;
      print('$checkCount   -->   $ratioSnip');
      print('$rakeWordSnip    -->     $ratioRakeSnip');
      // print(
      //     'Levenshtein    -->     ${1 - l.normalizedDistance(rakeWordSnip, q)}');
      // print('Jaccard    -->     ${1 - j.normalizedDistance(rakeWordSnip, q)}');

      // if (ratioSnip >= 0.30 || ratioTitle >= 0.35)

      if (ratioRakeSnip >= 0.45 || ratioSnip >= 0.40) {
        // print('Ratios are for $i : $ratioSnip and $ratioTitle');
        // print('Rake for $i are : $rakeWordSnip and $rakeWordTitle');
        // print('');
        totalMatched++;
        // checkCount++;
        // print('$checkCount  -->   $ratioSnip  -->   $ratioTitle');
        // print('$rakeWordSnip  -->  $rakeWordTitle');
        // print('');
        int checkFakeMatched = fakeMatched;

        for (int j = 0; j < wordSet.length; j++) {
          if (rakeWordSnip.contains(wordSet[j]) ||
              rakeWordTitle.contains(wordSet[j]) ||
              wordUrl.contains(wordSet[j])) {
            if (!isFakeChecked) {
              descriptionToSend = decodeJson1['items'][i]['pagemap']['metatags']
                  [0]['og:description'];
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
                ['metatags'][0]['og:description'];
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
      // print('$i     $percentage');
    }

    try {
      percentage =
          ((fakeMatched.toDouble() / totalMatched.toDouble()) * 100.0).toInt();
    } catch (e) {
      print(e);
    }

    if (percentage < 50) {
      descriptionToSend = decodeJson1['items'][posForTrue]['pagemap']
          ['metatags'][0]['og:description'];
      imageLinkToSend = decodeJson1['items'][posForTrue]['pagemap']['metatags']
          [0]['og:image'];
      siteNameToSend = decodeJson1['items'][posForTrue]['pagemap']['metatags']
          [0]['og:site_name'];
      titleToSend = decodeJson1['items'][posForTrue]['title'];
      formattedUrlToSend = decodeJson1['items'][posForTrue]['formattedUrl'];
      // snippetToSend = decodeJson1['items'][posForTrue]['snippet'];
    }

    // print('$titleToSend  ->  $formattedUrlToSend   ->   $descriptionToSend'
    //     '  ->  $siteNameToSend  ->  $imageLinkToSend');

    // Display Link not required

    // Formatted url only to check fake

    if (descriptionToSend == null) {}

    return percentage;
  }
}
