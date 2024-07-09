import "dart:convert";
import "package:flutter/material.dart";
import "package:hive/hive.dart";
import 'package:http/http.dart' as http;

class API {
  static final baseURL = "https://mmvip.smartcodemm.com";

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

    var SettingAPI = Hive.box("SettingData").get("settings");
    var response = await http.get(Uri.parse(SettingAPI["api"] == null
        ? "http://2d3d.link/main/api.php"
        : SettingAPI["api"]));
    print(SettingAPI);

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
      "updatetime": jsonData[0]["updatetime"],
    };
    print("shah" + TWODXD.toString());
    return TWODXD;
  }

  static Future<Map> getSettingDatas() async {
    final url = Uri.parse("https://mmvip.smartcodemm.com/api/setting");

    Map data = {};

    try {
      http.Response res = await http.get(url);
      print('setting..............');
      print(res);
      data.addAll(jsonDecode(res.body)[0]);
    } catch (e) {
      print(e);
    }

    return data;
  }

  static Future<List<Map<String, dynamic>>> getSlide() async {
    var response = await http.get(
      Uri.parse('https://mmvip.smartcodemm.com/api/slides'),
    );
    return json.decode(response.body).cast<Map<String, dynamic>>();
  }

  static Future<void> postToken(token) async {
    final url =
        Uri.parse("https://backend.mmvip.smartcodemm.com/api/device_token");

    try {
      http.Response res = await http.post(
        url,
        body: {
          "device_token": token,
        },
      );
      print(res.body);
      print("...........................................................");
    } catch (e) {
      print(e);
    }
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
