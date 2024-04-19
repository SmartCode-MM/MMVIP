import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmvip/Comp/API.dart';

class THLottery extends StatefulWidget {
  const THLottery({super.key});

  @override
  State<THLottery> createState() => _THLotteryState();
}

bool isloading = true;

List prizes = [];
String date = "";

class _THLotteryState extends State<THLottery> {
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
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        backgroundColor: Color(0xff053b61),
        title: Text(
          'Thai Lottery',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isloading
          ? Center(
              child: SpinKitFadingCircle(
              color: Colors.blue.shade400,
              size: 30,
            ))
          : Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            ...prizes.map((e) {
                              List numbers = e['number'];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Center(
                                        child: Text(
                                          '${e['name']} ${e['reward']}  ฿',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        ...numbers.map((i) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0),
                                            child: Container(
                                              // height: 50,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (numbers.length > 5
                                                      ? 0.2
                                                      : numbers.length == 1
                                                          ? 0.5
                                                          : 0.4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Center(
                                                  child: Text(
                                                    i,
                                                    style: TextStyle(
                                                        letterSpacing: 1,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            }),

                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 20),
                            //   child: Container(
                            //     // height: 50,
                            //     width: MediaQuery.of(context).size.width * 0.5,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Colors.white),
                            //     child: Padding(
                            //       padding:
                            //           const EdgeInsets.symmetric(vertical: 10),
                            //       child: Center(
                            //         child: Text(
                            //           '997626',
                            //           style: TextStyle(
                            //               letterSpacing: 1,
                            //               color: Colors.black,
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 18),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Center(
                            //     child: Text(
                            //       'Near First Price (100,000 ฿)',
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            // NearFirstPrice(),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Center(
                            //     child: Text(
                            //       'First 3 Digits (4,000 ฿)',
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            // First3Digits(),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Center(
                            //     child: Text(
                            //       'Last 3 Digits (4,000 ฿)',
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            // Last3Digits(),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Center(
                            //     child: Text(
                            //       'Last 3 Digits (4,000 ฿)',
                            //       style: TextStyle(
                            //           color: Colors.white,
                            //           fontSize: 18,
                            //           fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 20),
                            //   child: Container(
                            //     // height: 50,
                            //     width: MediaQuery.of(context).size.width * 0.5,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Colors.white),
                            //     child: Padding(
                            //       padding:
                            //           const EdgeInsets.symmetric(vertical: 10),
                            //       child: Center(
                            //         child: Text(
                            //           '997626',
                            //           style: TextStyle(
                            //               letterSpacing: 1,
                            //               color: Colors.black,
                            //               fontWeight: FontWeight.bold,
                            //               fontSize: 18),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.06,
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Colors.white),
                            //     child: Center(
                            //       child: Text(
                            //         'Second Prize (200,000 ฿)',
                            //         style: TextStyle(
                            //             color: Colors.grey.shade600,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Wrap(
                            //     spacing: 5,
                            //     runSpacing: 10,
                            //     children: [
                            //       SecondPrize(),
                            //       SecondPrize(),
                            //       SecondPrize(),
                            //       SecondPrize(),
                            //       SecondPrize(),
                            //       SecondPrize(),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.06,
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Colors.white),
                            //     child: Center(
                            //       child: Text(
                            //         'Third Prize (80,000 ฿)',
                            //         style: TextStyle(
                            //             color: Colors.grey.shade600,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Wrap(
                            //     spacing: 5,
                            //     runSpacing: 10,
                            //     children: [
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //       ThirdPrize(),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.06,
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Colors.white),
                            //     child: Center(
                            //       child: Text(
                            //         'Fourth Prize (40,000 ฿)',
                            //         style: TextStyle(
                            //             color: Colors.grey.shade600,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Wrap(
                            //     spacing: 5,
                            //     runSpacing: 10,
                            //     children: [
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //       FourthPrize(),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Container(
                            //     height:
                            //         MediaQuery.of(context).size.height * 0.06,
                            //     width: double.infinity,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Colors.white),
                            //     child: Center(
                            //       child: Text(
                            //         'Fifth Prize (20,000 ฿)',
                            //         style: TextStyle(
                            //             color: Colors.grey.shade600,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 10),
                            //   child: Wrap(
                            //     spacing: 5,
                            //     runSpacing: 10,
                            //     children: [
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //       FifthPrize(),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    color: Colors.grey.shade800,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/searchprize');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xff053b61)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Search Prize',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    ));
  }
}

class SecondPrize extends StatelessWidget {
  const SecondPrize({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      // height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Text(
            '997626',
            style: TextStyle(
                letterSpacing: 1,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class ThirdPrize extends StatelessWidget {
  const ThirdPrize({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      // height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Text(
            '997626',
            style: TextStyle(
                letterSpacing: 1,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class FourthPrize extends StatelessWidget {
  const FourthPrize({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      // height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Text(
            '997626',
            style: TextStyle(
                letterSpacing: 1,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class FifthPrize extends StatelessWidget {
  const FifthPrize({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.2,
      // height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Center(
          child: Text(
            '997626',
            style: TextStyle(
                letterSpacing: 1,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class Last3Digits extends StatelessWidget {
  const Last3Digits({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    '571',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              // height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    '509',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class First3Digits extends StatelessWidget {
  const First3Digits({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    '571',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              // height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    '509',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NearFirstPrice extends StatelessWidget {
  const NearFirstPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    '997626',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              // height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    '997626',
                    style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
