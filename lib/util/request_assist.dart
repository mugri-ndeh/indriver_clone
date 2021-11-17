import 'dart:convert';

import 'package:http/http.dart';

class RequestAssistant {
  static Future getRequest(String url) async {
    Response response = await get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String jsondata = response.body;
        var decodedData = jsonDecode(jsondata);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }
}
