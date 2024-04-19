import 'package:hive/hive.dart';

class TempLiveData {
  static void setTempLiveData(Map data) {
    Box tempBox = Hive.box("TempLiveData");
    tempBox.put("data", data);
  }

  static Map getTempLiveData() {
    Box tempBox = Hive.box("TempLiveData");
    return tempBox.get("data");
  }

  static void setApiCallTime(DateTime data) {
    Box tempBox = Hive.box("TempLiveData");
    tempBox.put("Time", data);
  }

  static DateTime getApiCallTime() {
    Box tempBox = Hive.box("TempLiveData");
    return tempBox.get("Time") ?? DateTime.now();
  }
}
