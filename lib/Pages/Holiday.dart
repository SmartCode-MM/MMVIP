import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmvip/Comp/API.dart';

class Holiday extends StatefulWidget {
  const Holiday({super.key});

  @override
  State<Holiday> createState() => _HolidayState();
}

List data = [];

bool isloading = true;

class _HolidayState extends State<Holiday> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        List t = await API.getHoliday();
        setState(() {
          data = t;
          isloading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff053b61),
          title: Text(
            'Set Holidays',
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
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data
                          .map((e) => HolidayCard(
                              date: e["date"], desc: e["description"]))
                          .toList(),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class HolidayCard extends StatelessWidget {
  const HolidayCard({
    required this.date,
    required this.desc,
    super.key,
  });

  final String date;
  final String desc;

  @override
  Widget build(BuildContext context) {
    print(date);
    print(desc);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
                fontSize: 14,
                color: Color(0xff053b61),
                fontWeight: FontWeight.bold),
          ),
          Text(
            desc,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
