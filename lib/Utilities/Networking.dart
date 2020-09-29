import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Networking {
  readFilesFromAssets() async {
    // Users can load any kind of files like txt, doc or json files as well
    String assetContent = await rootBundle.loadString('apiFile.txt');
    return assetContent;
  }

  Future getData(String q) async {
    String key = await readFilesFromAssets();
    String engineId = '306d2336ed7e743ae';
    int i, j;
    // q = q.replaceAll(' ', '+');
    // print(q);
    q = q.replaceAll('://', '+');
    if (q.contains('http')) {
      i = q.indexOf('http');
    } else if (q.contains('http')) {
      i = q.indexOf('https');
    }

    if (q.contains('co'))
      j = q.indexOf('co');
    else if (q.contains('com')) {
      j = q.indexOf('com');
    }

    print("$i" + " " + "$j");
    q = q.replaceFirst(q.substring(i + 5, j), ' ');
    q = q.replaceAll(' ', '+');
    print(q);
    http.Response response1 = await http.get(Uri.encodeFull(
        'https://www.googleapis.com/customsearch/v1?key=$key&cx=$engineId&q=$q&safe=1'));
    //http.Response response2 = await http.get(Uri.encodeFull(
    //'https://www.googleapis.com/customsearch/v1?key=$key&cx=$engineId&q=$q&safe=1&start=11'));
    if (response1.statusCode == 200 /* && response1.statusCode == 200*/) {
      String data1 = response1.body;
      // print(data1);
      // String data2 = response2.body;
      return data1 /* + '%*!@#Debuggers will beat everyone%*!@#' + data2*/;
    } else {
      print(response1.statusCode);
      //   print(response2.statusCode);
    }
  }
}
