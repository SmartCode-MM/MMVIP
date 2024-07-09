import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mmvip/Comp/API.dart';
import 'package:mmvip/Comp/Admob.dart';

class ThreeDHistory extends StatefulWidget {
  const ThreeDHistory({super.key});

  @override
  State<ThreeDHistory> createState() => _ThreeDHistoryState();
}

int selectedyear = DateTime.now().year;
bool isloading = true;

List threedhis = [];

class _ThreeDHistoryState extends State<ThreeDHistory> {
  BannerAd? banner;

  void loadAds() async {
    banner = await MMVIPAdMob.getBanner(
      context,
      height: 100,
    );
    banner?.load();
  }

  @override
  void dispose() {
    if (banner != null) {
      banner!.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        threedhis = await API.get3Dhis(selectedyear);
        setState(() {
          isloading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (banner == null) {
      loadAds();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff053b61),
        title: Text(
          '3D History',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isloading
          ? Center(
              child: SpinKitFadingCircle(
              color: Color(0xff053b61),
              size: 30,
            ))
          : Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              selectedyear -= 1;
                              threedhis = await API.get3Dhis(selectedyear);

                              setState(() {});
                            },
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  selectedyear.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              selectedyear += 1;
                              threedhis = await API.get3Dhis(selectedyear);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 5,
                      runSpacing: 10,
                      children: [
                        ...threedhis.map((e) {
                          return ThreeHisWid(
                              month: e['month'], numbers: e['numbers']);
                        })
                      ],
                    ),
                    ThreeDAds(banner: banner),
                  ],
                ),
              ),
            ),
    );
  }
}

class ThreeHisWid extends StatelessWidget {
  const ThreeHisWid({
    required this.month,
    required this.numbers,
    super.key,
  });

  final String month;
  final List numbers;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 150,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff053b61)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        month,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      ...numbers.map((numbrow) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                numbrow['date'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Text(
                                numbrow['number'],
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.22,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xff053b61)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                month,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: Colors.white,
              height: 1,
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...numbers.map((numb) {
                        return Text(
                          numb["number"],
                          style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThreeDAds extends StatefulWidget {
  const ThreeDAds({
    super.key,
    required this.banner,
  });

  final BannerAd? banner;

  @override
  State<ThreeDAds> createState() => _ThreeDAdsState();
}

class _ThreeDAdsState extends State<ThreeDAds> {
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
                height: 120,
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
