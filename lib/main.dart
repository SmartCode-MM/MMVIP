import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mmvip/Comp/API.dart';
import 'package:mmvip/Comp/Firebase_API.dart';
import 'package:mmvip/Comp/firebaseURL.dart';

import 'package:mmvip/Pages/ChatDetails.dart';
import 'package:mmvip/Pages/Gift.dart';
import 'package:mmvip/Pages/GiftDetails.dart';
import 'package:mmvip/Pages/Holiday.dart';
import 'package:mmvip/Pages/Home.dart';
import 'package:mmvip/Pages/LiveChat.dart';
import 'package:mmvip/Pages/Privacy.dart';
import 'package:mmvip/Pages/SearchPrize.dart';
import 'package:mmvip/Pages/Splash.dart';
import 'package:mmvip/Pages/Taiwan.dart';
import 'package:mmvip/Pages/ThLottery.dart';
import 'package:mmvip/Pages/ThreeDHistory.dart';
import 'package:mmvip/Pages/TwoDHistory.dart';
import 'package:mmvip/Provider/locale.dart';
import 'dart:io' show Platform;
import 'package:mmvip/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyAGHF3-qedKRSfH14n5i8WfyRaD90VaYf0",
              appId: "1:760132802717:android:826448c04150c2c7265c74",
              messagingSenderId: "760132802717",
              projectId: "mmvip-fc109"))
      : await Firebase.initializeApp();
  await FirebaseAPI().initNotifications();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  await Hive.openBox("TempLiveData");
  await Hive.openBox('PresentData');
  await Hive.openBox('Slides');
  Box settingBox = await Hive.openBox("SettingData");
  await Hive.openBox('Language');
  Box miscbox = await Hive.openBox("MiscBox");
  await FireMSG().initNoti();
  Map settingData = await API.getSettingDatas();
  settingBox.put(
    "settings",
    settingData,
  );
  if (Hive.box("Language").get('lang') == null) {
    Hive.box("Language").put('lang', 'en');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
            title: 'MMVIP',
            theme: ThemeData(
              useMaterial3: true,
            ),
            locale: provider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialRoute: "/splash",
            routes: {
              "/splash": (context) => const Splash(),
              "/home": (context) => const HomePage(),
              "/taiwan": (context) => const Taiwan(),
              "/threeDhis": (context) => const ThreeDHistory(),
              "/searchprize": (context) => const SearchPrize(),
              "/twoDhis": (context) => const TwoDHistory(),
              "/gift": (context) => const Gift(),
              "/livechat": (context) => const LiveChat(
                    // userName: 'defaultUserName',
                    //     userProfilePic: 'defaultProfilePic',
                    liveData: 'defaultLiveData',
                    number1: 'defaultNumber1',
                    set1: 'defaultSet1',
                    value1: 'defaultValue1',
                    number2: 'defaultNumber2',
                    set2: 'defaultSet2',
                    value2: 'defaultValue2',
                  ),
              "/holiday": (context) => const Holiday(),

              "/thailand": (context) => const THLottery(),
              "/presentDetail": (context) => PresentDetail(),
              "/privacy": (context) => const Privacy(),

              // "/2Ddetailspage": (context) => const TwoDDetails(),

              // "/2Devening": (context) => const TwoDevening(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/chatdetails') {
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (context) {
                    return ChatDetails(
                      userName: args['userName'],
                      userProfilePic: args['userProfilePic'],
                      liveData: args['liveData'],
                      number1: args['number1'],
                      set1: args['set1'],
                      value1: args['value1'],
                      number2: args['number2'],
                      set2: args['set2'],
                      value2: args['value2'],
                    );
                  },
                );
              }
            });
      },
    );
  }
}
