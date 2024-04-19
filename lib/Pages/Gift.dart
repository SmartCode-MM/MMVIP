import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mmvip/Comp/Admob.dart';

class Gift extends StatefulWidget {
  const Gift({super.key});

  @override
  State<Gift> createState() => _GiftState();
}

bool isloading = true;

class _GiftState extends State<Gift> {
  BannerAd? banner;

  InterstitialAd? interAd;

  createInterAd() async {
    await InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712",
      // adUnitId: "ca-app-pub-7546836867022515/5610805044",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        interAd = ad;
      }, onAdFailedToLoad: (err) {
        print(err);
        interAd = null;
      }),
    );
  }

  void showInter(Function after) {
    print(interAd);
    if (interAd != null) {
      interAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createInterAd();
          after();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print(error);
          ad.dispose();
          createInterAd();
          after();
        },
      );
      interAd!.show();
      interAd = null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isloading = false;
        });
      });
      await createInterAd();
    });
  }

  @override
  void dispose() {
    if (interAd != null) {
      interAd!.dispose();
    }
    if (banner != null) {
      banner!.dispose();
    }
    super.dispose();
  }

  void loadAds() {
    banner = MMVIPAdMob.getBanner(
      context,
      height: 100,
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      loadAds();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade800,
        appBar: AppBar(
          backgroundColor: Color(0xff053b61),
          title: Text(
            'Gift',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
        ),
        body: isloading
            ? Center(
                child: SpinKitFadingCircle(
                color: Colors.blue.shade400,
                size: 30,
              ))
            : Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue),
                              ),
                            ),
                            Row(
                              children: [
                                GiftBox(),
                                SizedBox(
                                  width: 10,
                                ),
                                GiftBox(),
                                SizedBox(
                                  width: 10,
                                ),
                                GiftBox(),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                GiftBox(),
                                SizedBox(
                                  width: 10,
                                ),
                                GiftBox(),
                                SizedBox(
                                  width: 10,
                                ),
                                GiftBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GiftAds(banner: banner),
                  ],
                ),
              ),
      ),
    );
  }
}

class GiftBox extends StatelessWidget {
  const GiftBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120,
        // width: 50,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff053b61)),
        child: Center(
          child: Text(
            '2D တစ်ရက်စာ',
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class GiftAds extends StatefulWidget {
  const GiftAds({
    super.key,
    required this.banner,
  });

  final BannerAd? banner;

  @override
  State<GiftAds> createState() => _GiftAdsState();
}

class _GiftAdsState extends State<GiftAds> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: widget.banner == null
            ? Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 200,
                child: Center(
                  child: Text('Google Ads Banner'),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                ),
                width: double.infinity,
                height: 100,
                child: AdWidget(ad: widget.banner!),
              ),
      ),
    );
  }
}
