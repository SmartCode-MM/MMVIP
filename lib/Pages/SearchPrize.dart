import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mmvip/Comp/API.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SearchPrize extends StatefulWidget {
  const SearchPrize({super.key});

  @override
  State<SearchPrize> createState() => _SearchPrizeState();
}

bool isloading = true;

List prizes = [];
String date = "";

class _SearchPrizeState extends State<SearchPrize> {
  TextEditingController contxt = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Map data = await API.getthaiFromoutside();
      prizes = data['prizes'];
      date = data['date'];
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Color(0xff053b61),
          title: Text(
            'Search Prize',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    'Enter Lottery Digits',
                    style: TextStyle(
                        color: Color(0xff053b61),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  keyboardType: TextInputType.phone,
                  obscureText: false,
                  cursorColor: Color(0xff053b61),
                  textStyle: TextStyle(color: Color(0xff053b61)),
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeFillColor: Colors.white,
                      activeColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.white,
                      selectedColor: Colors.white,
                      selectedFillColor: Colors.white),
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: contxt,
                  onCompleted: (v) {
                    print("Completed");
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  Map win = {};
                  bool ispar = false;
                  for (Map d in prizes) {
                    String contexxt = contxt.text;
                    if (d['pattern'] == null) {
                      contexxt = contxt.text;
                    } else {
                      List patt = d['pattern'].toString().split(",");
                      if (patt[0] == 'first') {
                        contexxt = contxt.text.substring(0, int.parse(patt[1]));
                      } else if (patt[0] == 'last') {
                        contexxt = contxt.text
                            .substring(contxt.text.length - int.parse(patt[1]));
                      }
                    }

                    List i = d['number'];
                    if (i.contains(contexxt)) {
                      ispar = true;
                      win = d;
                    }
                  }
                  if (ispar == false) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'lib/IMG/sad.gif',
                                          height: 70,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            'Prize Not Found!',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xff053b61)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      },
                    );
                  } else {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'lib/IMG/cele.gif',
                                          height: 70,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 5),
                                          child: Text(
                                            'Congratulations',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                win['name'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                ' Winner',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                win['reward'],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                              Text(
                                                ' Baht',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Color(0xff053b61)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20),
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ));
                      },
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff053b61)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
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
