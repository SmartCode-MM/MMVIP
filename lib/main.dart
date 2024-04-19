import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mmvip/Pages/Gift.dart';
import 'package:mmvip/Pages/Holiday.dart';
import 'package:mmvip/Pages/Home.dart';
import 'package:mmvip/Pages/LiveChat.dart';
import 'package:mmvip/Pages/SearchPrize.dart';
import 'package:mmvip/Pages/Taiwan.dart';
import 'package:mmvip/Pages/ThLottery.dart';
import 'package:mmvip/Pages/ThreeDHistory.dart';
import 'package:mmvip/Pages/TwoDHistory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  await Hive.openBox("TempLiveData");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const HomePage(),
        "/taiwan": (context) => const Taiwan(),
        "/threeDhis": (context) => const ThreeDHistory(),
        "/searchprize": (context) => const SearchPrize(),
        "/twoDhis": (context) => const TwoDHistory(),
        "/gift": (context) => const Gift(),
        "/livechat": (context) => const LiveChat(),
        "/holiday": (context) => const Holiday(),
        "/thailand": (context) => const THLottery(),

        // "/2Ddetailspage": (context) => const TwoDDetails(),

        // "/2Devening": (context) => const TwoDevening(),
      },
    );
  }
}
