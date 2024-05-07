import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mmvip/Pages/Gift.dart';
import 'package:mmvip/Pages/GiftDetails.dart';
import 'package:mmvip/Pages/Holiday.dart';
import 'package:mmvip/Pages/Home.dart';
import 'package:mmvip/Pages/LiveChat.dart';
import 'package:mmvip/Pages/SearchPrize.dart';
import 'package:mmvip/Pages/Splash.dart';
import 'package:mmvip/Pages/Taiwan.dart';
import 'package:mmvip/Pages/ThLottery.dart';
import 'package:mmvip/Pages/ThreeDHistory.dart';
import 'package:mmvip/Pages/TwoDHistory.dart';
import 'package:mmvip/Provider/locale.dart';
import 'package:mmvip/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  await Hive.openBox("TempLiveData");
  await Hive.openBox('PresentData');
  await Hive.openBox('Language');
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
            "/livechat": (context) => const LiveChat(),
            "/holiday": (context) => const Holiday(),
            "/thailand": (context) => const THLottery(),
            "/presentDetail": (context) => const PresentDetail(),

            // "/2Ddetailspage": (context) => const TwoDDetails(),

            // "/2Devening": (context) => const TwoDevening(),
          },
        );
      },
    );
  }
}
