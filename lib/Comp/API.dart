import "dart:convert";
import "package:flutter/material.dart";
import "package:hive/hive.dart";
import 'package:http/http.dart' as http;

class API {
  static final baseURL = "https://app.aungthuya2d3d.link";

  static Future<List> getHoliday() async {
    var response = await http.get(Uri.parse('$baseURL/api/holiday'));
    List jsonData = jsonDecode(response.body);
    print(response.body);
    return jsonData;
  }

  static Future<Map> getthaiFromoutside() async {
    String url = "https://api.lottery.23pos.online/api/thai/result/latest";

    print(url);
    final response = await http.get(
      Uri.parse(url),
    );
    return json.decode(response.body);
  }

  static Future<Map> getmainapi() async {
    print("Fetching live data......");
    DateTime now = DateTime.now();
    DateTime t930 = DateTime(now.year, now.month, now.day, 9, 30);
    DateTime t12 = DateTime(now.year, now.month, now.day, 12, 1);

    DateTime t2 = DateTime(now.year, now.month, now.day, 14);
    DateTime t430 = DateTime(now.year, now.month, now.day, 16, 30);
    String SET;
    String VALUE;

    var response =
        await http.get(Uri.parse('http://newthaivip.com/main/api.php'));

    List jsonData = jsonDecode(response.body);
    if ((now.isBefore(t2))) {
      SET = jsonData[0]["1200set"];
      VALUE = jsonData[0]["1200value"];
    } else {
      SET = jsonData[0]["430set"];
      VALUE = jsonData[0]["430value"];
    }
    Map TWODXD = {
      "live": jsonData[0]["live"],
      "set": SET,
      "value": VALUE,
      "09:30 AM": [
        {
          "number": jsonData[0]["930internet"],
        },
        {
          "number": jsonData[0]["930modern"],
        }
      ],
      "12:01 PM": [
        {
          "set": jsonData[0]["1200set"],
          "value": jsonData[0]["1200value"],
          "number": jsonData[0]["1200"].toString().substring(2, 4),
        }
      ],
      "02:00 PM": [
        {
          "number": jsonData[0]["200internet"],
        },
        {
          "number": jsonData[0]["200modern"],
        }
      ],
      "04:30 PM": [
        {
          "set": jsonData[0]["430set"],
          "value": jsonData[0]["430value"],
          "number": jsonData[0]["430"],
        }
      ],
    };
    print("shah" + TWODXD.toString());
    return TWODXD;
  }

  static Future<List> getSlide() async {
    var response = await http.get(
      Uri.parse('https://backend.mmvip.smartcodemm.com/api/slides'),
    );
    Map jsonData = jsonDecode(response.body);
    return jsonData['data'];
  }

  static Future<List> get3Dhis(int year) async {
    String url = "https://mmvip.smartcodemm.com/api/3d/history?year=$year";

    print(url);
    final response = await http.get(
      Uri.parse(url),
    );
    return json.decode(response.body);
  }

  static Future<List> getPresents() async {
    final url = Uri.parse('https://mmvip.smartcodemm.com/api/presents');

    List data = [];

    try {
      http.Response res = await http.get(url);
      print(res.body);
      data.addAll(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return data;
  }

  static Future<Map> getEachPresent(id) async {
    final url = Uri.parse('https://mmvip.smartcodemm.com/api/present/$id');

    Map data = {};

    try {
      http.Response res = await http.get(url);
      print(res.body);
      data.addAll(jsonDecode(res.body));
    } catch (e) {
      print(e);
    }

    return data;
  }

  static Future<List> gettaiwan() async {
    String url = "https://mmvip.smartcodemm.com/api/taiwan";

    print(url);
    final response = await http.get(
      Uri.parse(url),
    );
    return json.decode(response.body);
  }

  static Future<List> get2Dhis(int month, int year) async {
    String url =
        "https://mmvip.smartcodemm.com/api/2d/history?month=$month&year=$year";
    print(url);
    final response = await http.get(
      Uri.parse(url),
    );

    Map days = {'Mon': 0, 'Tue': 1, 'Wed': 2, 'Thu': 3, 'Fri': 4};
    print(json.decode(response.body)[0]);
    List nulls = List.generate(
        days[json.decode(response.body)[0]['day']], (index) => null);

    return nulls + json.decode(response.body);
  }
}
