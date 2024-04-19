import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Taiwan extends StatefulWidget {
  const Taiwan({super.key});

  @override
  State<Taiwan> createState() => _TaiwanState();
}

bool isloading = true;

class _TaiwanState extends State<Taiwan> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff053b61),
          title: Text(
            'Taiwan',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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
                margin: EdgeInsets.all(15),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TaiwanCard(),
                      TaiwanCard(),
                      TaiwanCard(),
                      TaiwanCard(),
                      TaiwanCard(),
                      TaiwanCard(),
                      TaiwanCard(),
                      TaiwanCard(),
                      TaiwanCard(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class TaiwanCard extends StatelessWidget {
  const TaiwanCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xff053b61)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '2024-03-25',
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
                      'Result',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '64',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
