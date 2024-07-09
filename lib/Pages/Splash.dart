import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  AppOpenAd? appOpenAd;
  Future<void> loadAppOpenAd() async {
    final box = await Hive.openBox('SettingData');
    final settings = box.get('settings');
    final adUnitId = settings['ads_unit_app_open'];
    await AppOpenAd.load(
      // adUnitId: "ca-app-pub-7704805724466083/5964065783",
      adUnitId: adUnitId, // test
      // adUnitId: "ca-app-pub-3940256099942544/9257395921",
      // orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(),

      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) async {
          print(ad);
          appOpenAd = ad;

          appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              print('$ad onAdShowedFullScreenContent');
            },
            onAdDismissedFullScreenContent: (ad) async {
              print('$ad onAdDismissedFullScreenContent');
              // await checkcheck();
              Navigator.pushNamed(context, "/home");
              ad.dispose();
              appOpenAd = null;
              // loadAppOpenAd();
            },
          );
          // ad.fullScreenContentCallback = FullScreenContentCallback(
          //   onAdDismissedFullScreenContent: (ad) {
          //     print('$ad onAdDismissedFullScreenContent');
          //     ad.dispose();
          //   },
          // );

          await appOpenAd!.show();

          print("APPOPEN_DONE???");
          print("77777777777777777777777777777777777777");
        },
        onAdFailedToLoad: (error) async {
          // await checkcheck();
          Navigator.pushNamed(context, "/home");
          print('AppOpenAd failed to load: $error');
          print("99999999999999999999999999999999999999");
          // Handle the error.
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      WidgetsFlutterBinding.ensureInitialized();
      MobileAds.instance.initialize();
      await Hive.initFlutter();
      await Hive.openBox("TempLiveData");
      await loadAppOpenAd();
      await Future.delayed(Duration(seconds: 3));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff053b61),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              'lib/IMG/LOGO.png',
              height: 150,
            ),
          ),
          SpinKitFadingCircle(
            color: Colors.white,
            size: 30,
          )
        ],
      ),
    );
  }
}
