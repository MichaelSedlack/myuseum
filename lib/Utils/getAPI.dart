import 'package:http/http.dart' as http;
import 'dart:convert';

class Register {
  static Future<String> sendRegisterGetStatusCode(String url,
      String content) async
  {
    String ret = "";

    try {
      http.Response response = await http.post(
          Uri.parse(url), body: utf8.encode(content),
          headers:
          {
            "Accept": "Application/json",
            "Content-Type": "application/json",
          },
          encoding: Encoding.getByName("utf-8")
      );
      ret = response.statusCode.toString();
    }

    catch (e) {
      print(e.toString());
    }

    return ret;
  }

  static Future<String> sendRegisterGetBody(String url, String content) async
  {
    String ret = "";

    try {
      http.Response response = await http.post(
          Uri.parse(url), body: utf8.encode(content),
          headers:
          {
            "Accept": "Application/json",
            "Content-Type": "application/json",
          },
          encoding: Encoding.getByName("utf-8")
      );
      ret = response.body;
    }

    catch (e) {
      print(e.toString());
    }

    return ret;
  }
}