import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mmvip/Comp/API.dart';
import 'package:mmvip/Pages/ChatDetails.dart';

class LiveChat extends StatefulWidget {
  final String liveData;
  final String number1;
  final String set1;
  final String value1;
  final String number2;
  final String set2;
  final String value2;

  const LiveChat({
    super.key,
    required this.liveData,
    required this.number1,
    required this.set1,
    required this.value1,
    required this.number2,
    required this.set2,
    required this.value2,
  });

  @override
  State<LiveChat> createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  late Timer _timer;
  String _liveData = '';
  String _number1 = '';
  String _set1 = '';
  String _value1 = '';
  String _number2 = '';
  String _set2 = '';
  String _value2 = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _checkIfUserIsSignedIn();
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      var data = await API.getmainapi(); // Replace with your API call
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          _liveData = data['liveData'] ?? "";
          _number1 = data['number1'] ?? "";
          _set1 = data['set1'] ?? "";
          _value1 = data['value1'] ?? "";
          _number2 = data['number2'] ?? "";
          _set2 = data['set2'] ?? "";
          _value2 = data['value2'] ?? "";
        });
      }
    });
  }

  Future<void> _checkIfUserIsSignedIn() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      _navigateToChatDetails(firebaseUser);
    }
  }

  Future<void> _handleGoogleBtnClick() async {
    setState(() {
      _isSigningIn = true;
      _errorMessage = null;
    });

    try {
      final UserCredential userCredential = await _signInWithGoogle();
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        _navigateToChatDetails(firebaseUser);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Sign-in failed. Please try again.';
      });
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    // Check if the user cancelled the sign-in
    if (googleSignInAccount == null) {
      throw Exception('Sign-in aborted by user');
    }

    // Obtain the GoogleSignInAuthentication object
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    // Create a new credential
    OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // Sign in to Firebase with the Google credential
    return await _auth.signInWithCredential(credential);
  }

  void _navigateToChatDetails(User firebaseUser) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetails(
          liveData: widget.liveData,
          number1: widget.number1,
          set1: widget.set1,
          value1: widget.value1,
          number2: widget.number2,
          set2: widget.set2,
          value2: widget.value2,
          userName: firebaseUser.displayName ?? 'No Name',
          userProfilePic: firebaseUser.photoURL ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xff053b61),
      appBar: AppBar(
        backgroundColor: Color(0xff053b61),
        title: Text(
          'Live Chat',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  color: Color(0xff053b61),
                  child: Image.asset(
                    'lib/IMG/LOGO.png',
                    height: 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Sign into Chat',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              _isSigningIn
                  ? Center(
                      child: SpinKitFadingCircle(
                      color: Color(0xff053b61),
                      size: 30,
                    ))
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration:
                          BoxDecoration(color: Color(0xfffffaf6), boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset: Offset(0, 3),
                        )
                      ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: () {
                            _handleGoogleBtnClick();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image.asset(
                                  'lib/IMG/google.jpg',
                                  height: 30,
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Center(
                                  child: Text(
                                    'Sign In with Google',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }
}
