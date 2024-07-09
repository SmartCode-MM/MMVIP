import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';

class MMVIPAdMob {
  static dynamic getBanner(context, {padding = 40, height = 200}) async {
    final box = await Hive.openBox('SettingData');
    final settings = box.get('settings');
    final adUnitId = settings['ads_unit_smart_banner'];
    return BannerAd(
      size: AdSize.getInlineAdaptiveBannerAdSize(
          (MediaQuery.of(context).size.width.truncate() - padding).toInt(),
          height),
      adUnitId: adUnitId,
      // adUnitId: "ca-app-pub-7704805724466083/4913353358",
      // adUnitId: "ca-app-pub-7546836867022515/4395524785",

      listener: BannerAdListener(
        onAdClicked: (ad) => print("clicked"),
        onAdClosed: (ad) => print("close"),
        onAdFailedToLoad: (ad, err) => print('errrrrrr$err'),
        onAdLoaded: (ad) => print("loaded"),
        onAdOpened: (ad) => print("opened"),
      ),
      request: const AdRequest(),
    );
  }
}
