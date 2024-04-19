import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MMVIPAdMob {
  static dynamic getBanner(context, {padding = 40, height = 200}) {
    return BannerAd(
      size: AdSize.getInlineAdaptiveBannerAdSize(
          (MediaQuery.of(context).size.width.truncate() - padding).toInt(),
          height),
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
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
