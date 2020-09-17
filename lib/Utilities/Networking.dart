import 'package:http/http.dart' as http;
import 'dart:convert';

class Networking {
  Future getData(String q) async {
    List<dynamic> responseList;
    List queryHelper = q.split(' ');
    List removedWords = ['zindabad'];
    for (int i = 0; i < removedWords.length; i++) {
      if (queryHelper.contains(removedWords[i])) {
        queryHelper.remove(removedWords[i]);
      }
    }
    q = queryHelper.join('+');
    http.Response response1 = await http.get(
        'https://www.googleapis.com/customsearch/v1?key=AIzaSyAq5PYzfOx80-oP7fXKjwfNzs-yx7ZNpAs&cx=306d2336ed7e743ae&q=$q&safe=1');
    if (response1.statusCode == 200) {
      String data1 = response1.body;
      return jsonDecode(data1);
    } else {
      print(response1.statusCode);
    }
    return responseList;
  }
}
