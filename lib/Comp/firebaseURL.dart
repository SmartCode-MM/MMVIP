import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';

import 'api.dart';

class FireMSG {
  final _fireMsg = FirebaseMessaging.instance;
  Future<void> initNoti() async {
    NotificationSettings notiPermission = await _fireMsg.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );
    print(notiPermission);
    final CMToken = await _fireMsg.getToken();
    print("Token : $CMToken");
    if (Hive.box("MiscBox").get("tokenAdded") == null) {
      await API.postToken(CMToken);
      Hive.box("MiscBox").put("tokenAdded", 1);
      print("TK ADDED");
    } else {
      print("TK NOO");
    }
    _fireMsg.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // FirebaseMessaging.onBackgroundMessage((msg) async {
    //   print("Msgggg: $msg");
    // });
    FirebaseMessaging.onMessage.listen((event) {
      var noti = event.notification;
      print("Msg : $noti");
    });
  }
}
