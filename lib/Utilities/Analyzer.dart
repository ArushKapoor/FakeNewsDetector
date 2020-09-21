import 'dart:convert';
import 'package:fake_news_detector/Utilities/Networking.dart';
import 'package:flutter/material.dart';
import 'package:rake/rake.dart';
import 'package:document_analysis/document_analysis.dart';

class Analyzer {
  static String titleToSend;
  static String imageLinkToSend;
  static String siteNameToSend;
  static String snippetToSend;
  Networking obj = Networking();
  Future query(String q) async {
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
    Rake rake = Rake();
    int totalMatched = 0;
    int fakeMatched = 0;

    for (int i = 0; i < 10; i++) {
      String wordSnip, wordTitle, wordUrl;
      if (i < 10) {
        wordSnip = decodeJson1['items'][i]['snippet'];
        wordTitle = decodeJson1['items'][i]['title'];
        wordUrl = decodeJson1['items'][i]['formattedUrl'];
      }
      // else {
      //   wordSnip = decodeJson2['items'][i - 10]['snippet'];
      //   wordTitle = decodeJson2['items'][i - 10]['title'];
      //   wordUrl = decodeJson2['items'][i - 10]['formattedUrl'];
      // }
      String rakeWordSnip = rake.rank(wordSnip.toString()).toString();
      double ratioSnip =
          wordFrequencySimilarity(rakeWordSnip, rake.rank(q).toString());

      String rakeWordTitle = rake.rank(wordTitle.toString()).toString();
      double ratioTitle =
          wordFrequencySimilarity(rakeWordTitle, rake.rank(q).toString());

      wordUrl = wordUrl.replaceAll('-', ' ');
      wordUrl = wordUrl.replaceAll(',', ' ');
      wordUrl = wordUrl.replaceAll('/', ' ');
      wordUrl = wordUrl.replaceAll(':', ' ');
      wordUrl = wordUrl.replaceAll('.', ' ');
      wordUrl = wordUrl.replaceAll('_', ' ');

      if (ratioSnip >= 0.30 || ratioTitle >= 0.35) {
        // print('Ratios are for $i : $ratioSnip and $ratioTitle');
        // print('Rake for $i are : $rakeWordSnip and $rakeWordTitle');
        // print('');
        totalMatched++;

        for (int i = 0; i < wordSet.length; i++) {
          if (rakeWordSnip.contains(wordSet[i]) ||
              rakeWordTitle.contains(wordSet[i]) ||
              wordUrl.contains(wordSet[i])) {
            fakeMatched++;
            break;
          }
        }
      }
      // print('$i     $percentage');
    }

    int percentage =
        (fakeMatched.toDouble() / totalMatched.toDouble() * 100.0).toInt();

    // Display Link not required

    // Formatted url only to check fake

    // print(wordFrequencySimilarity(
    //     rake
    //         .rank(snip.join(" ") +
    //             title.join(" ") +
    //             link.join(" ") +
    //             url.join(" "))
    //         .toString(),
    //     wordset));
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
    // int percentage = (wordFrequencySimilarity(
    //             rake
    //                 .rank(snip.join(" ") +
    //                     title.join(" ") +
    //                     link.join(" ") +
    //                     url.join(" "))
    //                 .toString(),
    //             wordSet.toString()) *
    //         100)
    //     .toInt();
    return percentage;
  }
}
