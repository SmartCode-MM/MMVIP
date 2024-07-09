import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:mmvip/Comp/API.dart';
import 'package:mmvip/Comp/Admob.dart';
import 'package:url_launcher/url_launcher.dart';

class Gift extends StatefulWidget {
  const Gift({super.key});

  @override
  State<Gift> createState() => _GiftState();
}

bool isloading = true;

class _GiftState extends State<Gift> {
  Box presentBox = Hive.box("PresentData");
  List data = [];
  BannerAd? banner;
  List Slide = [];

  InterstitialAd? interAd;

  createInterAd() async {
    final box = await Hive.openBox('SettingData');
    final settings = box.get('settings');
    final adUnitId = settings['ads_unit_inter'];
    await InterstitialAd.load(
      adUnitId: adUnitId,
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
      Future.delayed(Duration.zero, () async {
        Slide = await API.getSlide();
        List PresentData = await API.getPresents();
        if (mounted) {
          setState(() {
            data = PresentData;

            isloading = false;
          });
        }

        presentBox.put(
          "presents",
          PresentData,
        );
      });
      Future.delayed(Duration(seconds: 2), () {});
      createInterAd();
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

  void loadAds() async {
    banner = await MMVIPAdMob.getBanner(
      context,
      height: 100,
    );
    banner?.load();
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      loadAds();
    }
    if (data.isEmpty && presentBox.get("presents") != null) {
      setState(() {
        data.addAll(presentBox.get("presents"));
      });
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
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Container(
                                width: double.infinity,
                                decoration:
                                    BoxDecoration(color: Colors.transparent),
                                child: CarouselSlider(
                                    items: Slide.map(
                                      (e) => GestureDetector(
                                        onTap: () async {
                                          if (e['link'] != null) {
                                            String url = e[
                                                'link']; // Assuming e['link'] is your URL
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          }
                                        },
                                        child: Image.network(
                                          e['image'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, exception, stackTrace) {
                                            return Center(
                                              child: Image.asset(
                                                'lib/Img/placeholderr.jpeg',
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ).toList(),
                                    options: CarouselOptions(
                                      height: 200,
                                      viewportFraction: 1,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      enlargeCenterPage: false,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 5),
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      onPageChanged: (index, reason) {},
                                      scrollDirection: Axis.horizontal,
                                    )),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              child: Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: [
                                  if (data.isEmpty) CircularProgressIndicator(),
                                  if (data.isNotEmpty)
                                    ...data
                                        .map((e) => GiftBox(
                                              title: e["name"]
                                                  .toString()
                                                  .split('\n')
                                                  .join('\n'),
                                              id: e["id"].toString(),
                                              ad: e["ad_type"],
                                            ))
                                        .toList(),
                                ],
                              ),
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

class GiftBox extends StatefulWidget {
  const GiftBox({
    required this.title,
    required this.id,
    required this.ad,
    super.key,
  });

  final String title;
  final String id;
  final String ad;

  @override
  State<GiftBox> createState() => _GiftBoxState();
}

class _GiftBoxState extends State<GiftBox> {
  bool isClicked = false;

  InterstitialAd? interAd;
  RewardedAd? rwAd;

  void createInterAd() async {
    final box = await Hive.openBox('SettingData');
    final settings = box.get('settings');
    final adUnitId = settings['ads_unit_inter'];

    InterstitialAd.load(
      adUnitId: adUnitId,
      // adUnitId: "ca-app-pub-7546836867022515/5610805044",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        interAd = ad;
      }, onAdFailedToLoad: (err) {
        print(err);
        print("dhahdah");
        interAd = null;
      }),
    );
  }

  Future<void> createRwAd() async {
    final box = await Hive.openBox('SettingData');
    final settings = box.get('settings');
    final adUnitId = settings['ads_unit_reward'];

    print("DDDDDDDDDDDDDDDDDDDdd");
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          print("ZZZZZZZZZZZZZZZZZZZZZ");
          setState(() {
            rwAd = ad;
          });
        },
        onAdFailedToLoad: (error) {
          print("PPPPPPPPPPPPPPPPPPPPp");
          print(error);
          setState(() {
            rwAd = null;
          });
        },
      ),
    );
  }

  int showRwAd(Function obtainPresent) {
    int status = 1;
    if (rwAd != null) {
      rwAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRwAd(); // Load a new ad for next show
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          status = 0;
          print("Failed to show ad: $error");
          ad.dispose();
          createRwAd(); // Load a new ad for next show
        },
      );
      rwAd!.show(onUserEarnedReward: (ad, reward) {
        obtainPresent();
      });
      rwAd = null; // Reset ad instance after showing
    } else {
      status = 0; // Set status to 0 if rwAd is null
    }
    return status;
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
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (timeStamp) async {

    //   },
    // );
    Box presentBox = Hive.box("PresentData");
    Future.delayed(Duration.zero, () async {
      List PresentData = await API.getPresents();
      presentBox.put(
        "presents",
        PresentData,
      );
    });

    createInterAd();
    createRwAd();
  }

  @override
  void dispose() {
    if (interAd != null) {
      interAd!.dispose();
    }
    super.dispose();
  }

  Future<Map> getPresentDetail() async {
    Map dt = await API.getEachPresent(widget.id);
    print(dt["content"]);
    print("-----------------------------------------------");
    return dt;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isClicked = true;
        });
        Map p = await getPresentDetail();
        if (p["ad_type"] == 'inter') {
          if (interAd == null) {
            print("dhahdah");
            Navigator.of(context).pushNamed("/presentDetail",
                arguments: [widget.title, p["type"], p["content"]]);
          } else {
            showInter(() {
              Navigator.of(context).pushNamed("/presentDetail",
                  arguments: [widget.title, p["type"], p["content"]]);
            });
          }
        } else if (p['ad_type'] == 'reward') {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.white,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(color: Color(0xff053b61)),
                              child: Center(
                                child: Text(
                                  'Congratulations !',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  Text(
                                    'Your Reward is ready to watch.',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  'Cancle',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              showRwAd(() {
                                                Navigator.pop(context);
                                                Navigator.of(context).pushNamed(
                                                    "/presentDetail",
                                                    arguments: [
                                                      widget.title,
                                                      p["type"],
                                                      p["content"]
                                                    ]);
                                              });
                                            },
                                            child: Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  )),
                                              child: Center(
                                                child: Text(
                                                  'Watch Ad',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        }
      },
      child: Container(
        height: 120,
        width: 100,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff053b61)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.title,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
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
                height: 70,
                child: Center(
                  child: Text('Google Ads Banner'),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                ),
                width: double.infinity,
                height: 70,
                child: AdWidget(ad: widget.banner!),
              ),
      ),
    );
  }
}

class Advertisement extends StatelessWidget {
  const Advertisement({
    required this.slides,
    Key? key,
  }) : super(key: key);

  final List<Map<String, dynamic>> slides;

  // Function to fetch slide data from API

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: slides.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> slide = slides[index];
        return Image.network(
          slide['image'],
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stackTrace) {
            return Center(
              child: Image.asset(
                'lib/Img/placeholderr.jpeg',
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      },
    );
  }
}
