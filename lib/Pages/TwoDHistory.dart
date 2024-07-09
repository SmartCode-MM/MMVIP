import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mmvip/Comp/API.dart';
import 'package:mmvip/Comp/Admob.dart';
import 'package:mmvip/Pages/ThreeDHistory.dart';

class TwoDHistory extends StatefulWidget {
  const TwoDHistory({super.key});

  @override
  State<TwoDHistory> createState() => _TwoDHistoryState();
}

bool isloading = true;

int selectedyear = DateTime.now().year;
int selectedmonth = DateTime.now().month;
List twodhis = [];

class _TwoDHistoryState extends State<TwoDHistory> {
  Map months = {
    '1': 'Jan',
    '2': 'Feb',
    '3': 'Mar',
    '4': 'Apr',
    '5': 'May',
    '6': 'Jun',
    '7': 'Jul',
    '8': 'Aug',
    '9': 'Sep',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec'
  };

  List monthyway = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  int currentYear = DateTime.now().year;

  List<int> pastyears = [];

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
    pastyears = List.generate(12, (index) => currentYear - index);
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        twodhis = await API.get2Dhis(selectedmonth, selectedyear);
        setState(() {
          isloading = false;
        });
      },
    );
  }

  void changedselectedmonth(month) {
    selectedmonth = int.parse(month.toString());
    setState(() {});
  }

  void changedselectedyear(year) {
    selectedyear = int.parse(year.toString());
    setState(() {});
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
          backgroundColor: Color(0xff053b61),
          title: Text(
            '2D History',
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
                                if (selectedmonth == 1) {
                                  selectedmonth = 12;
                                  selectedyear -= 1;
                                } else {
                                  selectedmonth -= 1;
                                }
                                twodhis = await API.get2Dhis(
                                    selectedmonth, selectedyear);
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
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return monthyeardialog(
                                          selectedyear: selectedyear,
                                          months: months,
                                          changedselectedmonth:
                                              changedselectedmonth,
                                          changedselectedyear:
                                              changedselectedyear,
                                          selectedmonth: selectedmonth,
                                          pastyears: pastyears);
                                    },
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        months[selectedmonth.toString()],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ", ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        selectedyear.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (selectedmonth == 12) {
                                  selectedmonth = 1;
                                  selectedyear += 1;
                                } else {
                                  selectedmonth += 1;
                                }
                                twodhis = await API.get2Dhis(
                                    selectedmonth, selectedyear);
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Mon',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Tue',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Wed',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Thu',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  'Fri',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            ...twodhis.map((e) {
                              if (e == null) {
                                return Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.18,
                                );
                              }
                              return TwoDHisCard(
                                  numbers: e['numbers'],
                                  date: e['date'].toString(),
                                  day: e['day'].toString());
                            })
                          ],
                        ),
                      ),
                      TwoDAds(banner: banner),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class Monthdetails extends StatelessWidget {
  const Monthdetails({
    required this.monthywayy,
    required this.currentmonth,
    required this.changed,
    required this.months,
    super.key,
  });

  final String monthywayy;
  final Map months;
  final int currentmonth;
  final Function changed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changed(monthywayy);
      },
      child: Container(
        width: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
            border: Border.all(
                width: 2,
                color: currentmonth.toString() == monthywayy
                    ? Color(0xff053b61)
                    : Colors.grey.shade100)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Center(
            child: Text(
              months[monthywayy],
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class Yeardetails extends StatelessWidget {
  const Yeardetails({
    required this.yearywayy,
    required this.currentyears,
    required this.changed,
    required this.years,
    super.key,
  });

  final int yearywayy;
  final List years;
  final int currentyears;
  final Function changed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changed(yearywayy);
      },
      child: Container(
        width: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade100,
            border: Border.all(
                width: 2,
                color: currentyears == yearywayy
                    ? Color(0xff053b61)
                    : Colors.grey.shade100)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Center(
            child: Text(
              yearywayy.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

class modernint extends StatelessWidget {
  const modernint({
    required this.modern930,
    required this.modern200,
    required this.internet200,
    required this.internet930,
    super.key,
  });

  final Map modern930;
  final Map modern200;
  final Map internet200;
  final Map internet930;

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
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'INTERNET',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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
                    '09:30 AM',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    modern930['number'],
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    internet930['number'],
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
                    '02:00 PM',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    modern200['number'],
                    style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Expanded(
                    child: Center(
                  child: Text(
                    internet200['number'],
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

class datetime extends StatelessWidget {
  datetime({
    required this.date,
    required this.day,
    super.key,
  });

  Map months = {
    '1': 'Jan',
    '2': 'Feb',
    '3': 'Mar',
    '4': 'Apr',
    '5': 'May',
    '6': 'Jun',
    '7': 'Jul',
    '8': 'Aug',
    '9': 'Sep',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec'
  };

  final String day;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ' : ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ' : ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  months[selectedmonth.toString()],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  ' ',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  selectedyear.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class twodcard430 extends StatelessWidget {
  const twodcard430({
    required this.TwooD0430,
    super.key,
  });

  final Map TwooD0430;

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
                TwooD0430['time'],
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
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          TwooD0430['set'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
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
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          TwooD0430['value'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
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
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          TwooD0430['number'],
                          style: TextStyle(
                              color: Colors.yellow.shade300,
                              fontSize: 22,
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

class twodcard1201 extends StatelessWidget {
  const twodcard1201({
    required this.TwooD1201,
    super.key,
  });

  final Map TwooD1201;

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
                TwooD1201['time'],
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
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          TwooD1201['set'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
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
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          TwooD1201['value'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
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
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          TwooD1201['number'],
                          style: TextStyle(
                              color: Colors.yellow.shade300,
                              fontSize: 22,
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

class TwoDHisCard extends StatelessWidget {
  const TwoDHisCard({
    required this.numbers,
    required this.date,
    required this.day,
    super.key,
  });

  final List numbers;
  final String day;
  final String date;

  @override
  Widget build(BuildContext context) {
    print(numbers);
    Map modern930 = numbers
        .where((element) =>
            element['name'] == "Modern" && element['time'] == "09:30 AM")
        .toList()[0];
    Map modern200 = numbers
        .where((element) =>
            element['name'] == "Modern" && element['time'] == "02:00 PM")
        .toList()[0];
    Map internet930 = numbers
        .where((element) =>
            element['name'] == "Internet" && element['time'] == "09:30 AM")
        .toList()[0];
    Map internet200 = numbers
        .where((element) =>
            element['name'] == "Internet" && element['time'] == "02:00 PM")
        .toList()[0];
    Map TwooD1201 = numbers
        .where((element) =>
            element['name'] == "2D" && element['time'] == "12:01 PM")
        .toList()[0];
    Map TwooD0430 = numbers
        .where((element) =>
            element['name'] == "2D" && element['time'] == "04:30 PM")
        .toList()[0];

    return GestureDetector(
      onTap: () {
        if (TwooD1201 != null &&
            TwooD1201['set'] != null &&
            TwooD1201['value'] != null &&
            TwooD0430 != null &&
            TwooD0430['set'] != null &&
            TwooD0430['value'] != null) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(color: Colors.black)),
                                  child: Icon(
                                    Icons.close_sharp,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                          datetime(
                            date: date,
                            day: day,
                          ),
                          twodcard1201(
                            TwooD1201: TwooD1201,
                          ),
                          twodcard430(
                            TwooD0430: TwooD0430,
                          ),
                          modernint(
                            internet200: internet200,
                            internet930: internet930,
                            modern200: modern200,
                            modern930: modern930,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.18,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Color(0xff053b61)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                date,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  TwooD1201['number'],
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                TwooD0430['number'],
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TwoDAds extends StatefulWidget {
  const TwoDAds({
    super.key,
    required this.banner,
  });

  final BannerAd? banner;

  @override
  State<TwoDAds> createState() => _TwoDAdsState();
}

class _TwoDAdsState extends State<TwoDAds> {
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
                height: 150,
                child: Center(
                  child: Text('Google Ads Banner'),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                ),
                width: double.infinity,
                height: 150,
                child: AdWidget(ad: widget.banner!),
              ),
      ),
    );
  }
}

class monthyeardialog extends StatefulWidget {
  const monthyeardialog({
    super.key,
    required this.months,
    required this.changedselectedmonth,
    required this.changedselectedyear,
    required this.pastyears,
    required this.selectedmonth,
    required this.selectedyear,
  });

  final Map months;
  final Function changedselectedmonth;
  final Function changedselectedyear;
  final List pastyears;
  final int selectedmonth;
  final int selectedyear;

  @override
  State<monthyeardialog> createState() => _monthyeardialogState();
}

class _monthyeardialogState extends State<monthyeardialog> {
  int selectedmonthhhh = DateTime.now().month;
  int selectedyearrr = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    selectedmonthhhh = widget.selectedmonth;
    selectedyearrr = widget.selectedyear;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(5),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    ...widget.months.keys.map(
                      (e) => Monthdetails(
                        monthywayy: e,
                        changed: (m) {
                          // widget.changedselectedmonth(m);
                          selectedmonthhhh = int.parse(m.toString());
                          setState(() {});
                        },
                        currentmonth: selectedmonthhhh,
                        months: widget.months,
                      ),
                    )
                  ],
                ),
                Divider(),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: [
                    ...widget.pastyears.map(
                      (e) => Yeardetails(
                        yearywayy: e,
                        changed: (m) {
                          // widget.changedselectedmonth(m);
                          selectedyearrr = int.parse(m.toString());
                          setState(() {});
                        },
                        currentyears: selectedyearrr,
                        years: widget.pastyears,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.changedselectedmonth(selectedmonthhhh);
                          widget.changedselectedyear(selectedyearrr);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              'Comfirm',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
