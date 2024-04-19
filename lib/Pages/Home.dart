import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marquee/marquee.dart';
import 'package:mmvip/Comp/API.dart';
import 'package:mmvip/Comp/Admob.dart';
import 'package:intl/intl.dart';
import 'package:mmvip/Comp/livehandler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

bool isloading = true;

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
    Wakelock.enable();
    now = DateTime.now();

    t930 = DateTime(now.year, now.month, now.day, 9, 30);
    t12 = DateTime(now.year, now.month, now.day, 12, 1);
    t1210 = DateTime(now.year, now.month, now.day, 12, 10);
    t2 = DateTime(now.year, now.month, now.day, 14);
    t430 = DateTime(now.year, now.month, now.day, 16, 30);
    WidgetsBinding.instance.addObserver(this);
    t = Timer.periodic(const Duration(seconds: 1), (timer) async {
      data = await API.getmainapi();
      TempLiveData.setTempLiveData(data);
      TempLiveData.setApiCallTime(DateTime.now());
      if (mounted) {
        setState(() {
          data = data;
          x = DateTime.now();
        });
      }
    });
    checkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      now = DateTime.now();
      t930 = DateTime(now.year, now.month, now.day, 9, 30);
      t12 = DateTime(now.year, now.month, now.day, 12, 1);
      t1210 = DateTime(now.year, now.month, now.day, 12, 10);
      t2 = DateTime(now.year, now.month, now.day, 14);
      t430 = DateTime(now.year, now.month, now.day, 16, 30);
      if ((now.isAfter(t930) &&
              now.isBefore(t1210) &&
              now.weekday != 6 &&
              now.weekday != 7 &&
              !isHidden) ||
          (now.isAfter(t2) &&
              now.isBefore(t430) &&
              now.weekday != 6 &&
              now.weekday != 7 &&
              !isHidden)) {
        if (!t!.isActive) {
          t = Timer.periodic(const Duration(seconds: 1), (timer) async {
            data = await API.getmainapi();
            TempLiveData.setTempLiveData(data);
            TempLiveData.setApiCallTime(DateTime.now());
            if (mounted) {
              setState(() {
                data = data;
                x = DateTime.now();
              });
            }
          });
        }
      } else {
        // Future.delayed(Duration.zero, () async {
        //   dt2 = await API.get2DXD();
        //   TempLiveData.setTempLiveData(dt2);
        //   TempLiveData.setApiCallTime(DateTime.now());
        //   if (mounted) {
        //     setState(() {
        //       dt2 = dt2;
        //       x = DateTime.now();
        //     });
        //   }
        // });
        if (t!.isActive) {
          t!.cancel();
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      data = await API.getmainapi();

      await createInterAd();
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  void dispose() {
    if (interAd != null) {
      interAd!.dispose();
    }
    if (t != null) {
      t!.cancel();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Wakelock.disable();
  }

  void loadAds() {
    banner = MMVIPAdMob.getBanner(
      context,
      height: 100,
    )..load();
  }

  DateTime dtime = DateTime.now();
  DateTime time = DateTime.now();
  bool isHidden = false;
  Map data = {};
  Timer? t;
  DateTime x = TempLiveData.getApiCallTime();
  late Timer checkTimer;
  late DateTime now;
  late DateTime t930;
  late DateTime t12;
  late DateTime t1210;
  late DateTime t2;
  late DateTime t430;

  DateTime convertDT(String dt) {
    List<String> seg = dt.split("  ");
    int day = int.parse(seg[0].substring(0, 2));
    int month = int.parse(seg[0].substring(3, 5));
    int year = int.parse(seg[0].substring(6, 10));
    int hour = int.parse(seg[1].substring(0, 2));
    int minute = int.parse(seg[1].substring(3, 5));
    int second = int.parse(seg[1].substring(6, 10));
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("State is........ ${state}");
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      print('pasueeeeee');
      t!.cancel();
      setState(() {
        isHidden = true;
      });
    }
    if (state == AppLifecycleState.resumed && isHidden) {
      Future.delayed(Duration.zero, () async {
        data = await API.getmainapi();
        TempLiveData.setTempLiveData(data);
        TempLiveData.setApiCallTime(DateTime.now());
        if (mounted) {
          setState(() {
            data = data;
            x = DateTime.now();
          });
        }
      });

      t = Timer.periodic(const Duration(seconds: 1), (timer) async {
        print("resumeeeeee");
        data = await API.getmainapi();
        TempLiveData.setTempLiveData(data);
        TempLiveData.setApiCallTime(DateTime.now());
        if (mounted) {
          setState(() {
            data = data;
            x = DateTime.now();
          });
        }
      });
      setState(() {
        print('Hidden set false');
        isHidden = false;
      });
    } // got
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      loadAds();
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xff053b61),
          centerTitle: true,
          title: Text(
            '2D Myanmar',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0))),
          width: MediaQuery.of(context).size.width * 0.65,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      color: Color(0xff053b61),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (interAd == null) {
                                print(interAd);
                                Navigator.pushNamed(context, '/thailand');
                              } else {
                                showInter(() {
                                  Navigator.pushNamed(context, '/thailand');
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    size: 30,
                                    color: Color(0xff053b61),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Thailand Lottery',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (interAd == null) {
                                print(interAd);
                                Navigator.pushNamed(context, '/taiwan');
                              } else {
                                showInter(() {
                                  Navigator.pushNamed(context, '/taiwan');
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.flag,
                                    size: 30,
                                    color: Color(0xff053b61),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Taiwan',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/holiday');
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Color(0xff053b61),
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Set Holidays',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  'https://www.facebook.com/profile.php?id=100086530074833&mibextid=ZbWKwL'));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/IMG/facebook.png',
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'FB Page',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              launchUrl(Uri.parse('https://t.me/MM2DVVIP'));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'lib/IMG/Tele.png',
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Telegram',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.share,
                                    size: 30,
                                    color: Color(0xff053b61),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 40,
                                    color: Color(0xff053b61),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Rate App',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shield,
                                    size: 30,
                                    color: Color(0xff053b61),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                        color: Color(0xff053b61),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff053b61),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5)),
                            color: Color(0xff053b61),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Row(
                              children: [
                                CountryFlag.fromCountryCode(
                                  'MM',
                                  height: 40,
                                  width: 30,
                                  borderRadius: 5,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Myanmar',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            color: Colors.blueGrey.shade300,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Row(
                              children: [
                                CountryFlag.fromCountryCode(
                                  'GB',
                                  height: 40,
                                  width: 30,
                                  borderRadius: 10,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'English',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        body: isloading
            ? Center(
                child: SpinKitFadingCircle(
                color: Color(0xff053b61),
                size: 30,
              ))
            : Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 20,
                        child: Marquee(
                          text:
                              'အသုံးပြုရပိုမိုအဆင်ပြေစေရန် VPN ချိတ်ဆက်ထားပေးပါ။',
                          blankSpace: 200,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Color(0xff052b61)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: Center(
                                child: (now.isAfter(t930) &&
                                            now.isBefore(t12) &&
                                            now.weekday != 6 &&
                                            now.weekday != 7) ||
                                        (now.isAfter(t2) &&
                                            now.isBefore(t430) &&
                                            now.weekday != 6 &&
                                            now.weekday != 7)
                                    ? AnimatedTextKit(
                                        animatedTexts: [
                                          FadeAnimatedText(
                                            data.isEmpty ? "" : data['live'],
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 80,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                        isRepeatingAnimation: true,
                                        repeatForever: true,
                                      )
                                    : Text(
                                        data.isEmpty ? "" : data["live"],
                                        style: const TextStyle(
                                            fontSize: 80,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 22,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    " " + DateFormat("MMM d y").format(x) + " ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  ClockTick()
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    data.isEmpty
                        ? CircularProgressIndicator()
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    TwoDCard1201(
                                      Number: data["12:01 PM"][0]["number"],
                                      SET: data["12:01 PM"][0]["set"],
                                      VAL: data["12:01 PM"][0]["value"],
                                      time: '12:01 PM',
                                    ),
                                    TwoDCard1201(
                                      Number: data["04:30 PM"][0]["number"],
                                      SET: data["04:30 PM"][0]["set"],
                                      VAL: data["04:30 PM"][0]["value"],
                                      time: '04:30 PM',
                                    ),
                                    MordernInt(
                                      time1: "09:30 AM",
                                      MODERN1: data["09:30 AM"][1]["number"],
                                      INTERNET1: data["09:30 AM"][0]["number"],
                                      time2: "02:00 PM",
                                      MODERN2: data["02:00 PM"][1]["number"],
                                      INTERNET2: data["02:00 PM"][0]["number"],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    HomeAds(banner: banner),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        color: Color(0xff053b61),
                      ),
                      // height: MediaQuery.of(context).size.height * 0.095,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    if (interAd == null) {
                                      print(interAd);
                                      Navigator.pushNamed(context, '/taiwan');
                                    } else {
                                      showInter(() {
                                        Navigator.pushNamed(context, '/taiwan');
                                      });
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'lib/IMG/Taiwan.png',
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/threeDhis');
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'lib/IMG/3D.png',
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/gift');
                                  },
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'lib/IMG/money-bag.png',
                                        height: 50,
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/twoDhis');
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'lib/IMG/calendar.png',
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/livechat');
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            'lib/IMG/live-chat.png',
                                            height: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class HomeAds extends StatefulWidget {
  const HomeAds({
    super.key,
    required this.banner,
  });

  final BannerAd? banner;

  @override
  State<HomeAds> createState() => _HomeAdsState();
}

class _HomeAdsState extends State<HomeAds> {
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
                height: 120,
                child: AdWidget(ad: widget.banner!),
              ),
      ),
    );
  }
}

class MordernInt extends StatelessWidget {
  const MordernInt({
    super.key,
    required this.time1,
    required this.MODERN1,
    required this.INTERNET1,
    required this.time2,
    required this.MODERN2,
    required this.INTERNET2,
  });

  final String time1;
  final String MODERN1;
  final String INTERNET1;
  final String time2;
  final String MODERN2;
  final String INTERNET2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Color(0xff053b61), borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Expanded(
                  child: Center(
                    child: Text(
                      'MODERN',
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'INTERNET',
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                    child: Center(
                  child: Text(
                    time1,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    MODERN1,
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    INTERNET1,
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Center(
                  child: Text(
                    time2,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    MODERN2,
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    INTERNET2,
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// class TwoDCard430 extends StatelessWidget {
//   const TwoDCard430({

//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//             color: Color(0xff053b61), borderRadius: BorderRadius.circular(10)),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             children: [
//               Text(
//                 '04:30 PM',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18),
//               ),
//               Divider(),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Text(
//                           'SET',
//                           style: TextStyle(
//                               color: Colors.white70,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           '1386.07',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Text(
//                           'VALUE',
//                           style: TextStyle(
//                               color: Colors.white70,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           '1386.07',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Text(
//                           '2D',
//                           style: TextStyle(
//                               color: Colors.white70,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           '77',
//                           style: TextStyle(
//                               color: Colors.yellow.shade300,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class TwoDCard1201 extends StatelessWidget {
  const TwoDCard1201({
    super.key,
    required this.time,
    required this.Number,
    required this.SET,
    required this.VAL,
  });

  final String time;
  final String Number;
  final String SET;
  final String VAL;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xff053b61), borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'SET',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          SET,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'VALUE',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          VAL,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '2D',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          Number,
                          style: TextStyle(
                              color: Colors.yellow.shade300,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClockTick extends StatefulWidget {
  const ClockTick({
    super.key,
  });

  @override
  State<ClockTick> createState() => _ClockTickState();
}

class _ClockTickState extends State<ClockTick> {
  Timer? t;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    t!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          DateFormat.jms().format(DateTime.now()),
          style: TextStyle(
              color: Color(0xffeaeaea),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
