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
    q = q.replaceAll(' ', '+');
    http.Response response1 = await http.get(Uri.encodeFull(
        'https://www.googleapis.com/customsearch/v1?key=$key&cx=$engineId&q=$q&safe=1'));

    if (response1.statusCode == 200) {
      String data1 = response1.body;
      return data1;
    } else {
      print(response1.statusCode);
    }
  }
}
