import 'dart:convert';
import 'package:http/http.dart' as http;

class Networking {
  Future getData(String q) async {
    List queryHelper = q.split(' ');
    q = queryHelper.join('+');
    http.Response response1 = await http.get(
        'https://www.googleapis.com/customsearch/v1?key=AIzaSyAUQBHw-MsjQHYAYDTBzduuRfmW5vh4RHc&cx=306d2336ed7e743ae&q=$q');
    http.Response response2 = await http.get(
        'https://www.googleapis.com/customsearch/v1?key=AIzaSyAUQBHw-MsjQHYAYDTBzduuRfmW5vh4RHc&cx=306d2336ed7e743ae&q=$q&start=10');
    if (response1.statusCode == 200 && response2.statusCode == 200) {
      String data1 = response1.body;
      String data2 = response2.body;
      return jsonDecode(data1);
    } else {
      print(response1.statusCode);
      print(response2.statusCode);
    }
  }
}
