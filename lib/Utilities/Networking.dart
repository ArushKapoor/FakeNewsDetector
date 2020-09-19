import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Networking {
  readFilesFromAssets() async {
    // Users can load any kind of files like txt, doc or json files as well
    String assetContent = await rootBundle.loadString('apiFile.txt');
    return assetContent;
  }

  Future getData(String q) async {
    List<dynamic> responseList;
    List queryHelper = q.split(' ');

    String key = await readFilesFromAssets();

    String engineId = '306d2336ed7e743ae';
    List removedWords = [
      'was',
      'a',
      ';',
      'his',
      'of',
      'the',
      'we' 'can',
      'that',
      'this',
      'is',
      'to',
      'by',
      '"',
      ',',
      'and',
      '.',
      'A',
      'an',
      'at',
      'for',
      'the',
      'which',
      'in',
      'HE',
      'If',
      'be',
      'up',
      'take',
      'it',
      'all',
      'your',
      'groups',
      'Thank',
      'You',
      'Very',
      'Important',
      'Please',
      'share',
      '..',
      '*',
      'from',
      'will',
      'any',
      'its',
      'has',
      'an',
      'as',
    ];
    for (int i = 0; i < removedWords.length; i++) {
      if (queryHelper.contains(removedWords[i])) {
        queryHelper.remove(removedWords[i]);
      }
    }
    q = queryHelper.join('+');
    http.Response response1 = await http.get(Uri.encodeFull(
        'https://www.googleapis.com/customsearch/v1?key=$key&cx=$engineId&q=$q&safe=1'));
    http.Response response2 = await http.get(Uri.encodeFull(
        'https://www.googleapis.com/customsearch/v1?key=$key&cx=$engineId&q=$q&safe=1&start=10'));
    if (response1.statusCode == 200 && response1.statusCode == 200) {
      String data1 = response1.body;
      String data2 = response2.body;
      return data1 + '%*!@#Debuggers will beat everyone%*!@#' + data2;
    } else {
      print(response1.statusCode);
      print(response2.statusCode);
    }
    return responseList;
  }
}
