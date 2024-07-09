import "dart:async";

import "package:animated_text_kit/animated_text_kit.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:google_sign_in/google_sign_in.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:mmvip/Comp/API.dart";
import "package:mmvip/Comp/livehandler.dart";
import "package:wakelock/wakelock.dart";

class ChatDetails extends StatefulWidget {
  final String userName;
  final String userProfilePic;
  final String liveData;
  final String number1;
  final String set1;
  final String value1;
  final String number2;
  final String set2;
  final String value2;

  const ChatDetails({
    Key? key,
    required this.userName,
    required this.userProfilePic,
    required this.liveData,
    required this.number1,
    required this.set1,
    required this.value1,
    required this.number2,
    required this.set2,
    required this.value2,
  }) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<DocumentSnapshot> _messages = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool islive = true;
  bool isloading = true;

  late Timer _dataUpdateTimer;
  Map data = {};

  late DateTime now;
  DateTime x = TempLiveData.getApiCallTime();
  late Timer checkTimer;
  late DateTime t930;
  late DateTime t12;
  late DateTime t1210;
  late DateTime t2;
  late DateTime t430;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _scrollController.addListener(_scrollListener);
    Wakelock.enable();
    now = DateTime.now();

    t930 = DateTime(now.year, now.month, now.day, 9, 30);
    t12 = DateTime(now.year, now.month, now.day, 12, 1);
    t1210 = DateTime(now.year, now.month, now.day, 12, 10);
    t2 = DateTime(now.year, now.month, now.day, 14);
    t430 = DateTime(now.year, now.month, now.day, 16, 30);
    // WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
    _dataUpdateTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) async {
      data = await API.getmainapi();
      TempLiveData.setTempLiveData(data);
      TempLiveData.setApiCallTime(DateTime.now());
      if (mounted) {
        setState(() {
          now = DateTime.now();
          data = data;
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
              now.weekday != 7) ||
          (now.isAfter(t2) &&
              now.isBefore(t430) &&
              now.weekday != 6 &&
              now.weekday != 7)) {
        islive = true;

        if (!_dataUpdateTimer!.isActive) {
          _dataUpdateTimer =
              Timer.periodic(const Duration(seconds: 1), (timer) async {
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
        islive = false;
        setState(() {});
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
        if (_dataUpdateTimer!.isActive) {
          _dataUpdateTimer!.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _dataUpdateTimer.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoadingMore &&
        _hasMore) {
      _fetchMoreMessages();
    }
  }

  void _fetchMessages() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .get();
    if (mounted) {
      setState(() {
        _messages = querySnapshot.docs;
        _hasMore = querySnapshot.docs.length == 20;
      });
    }
  }

  void _fetchMoreMessages() async {
    setState(() {
      _isLoadingMore = true;
    });

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(_messages.last)
        .limit(20)
        .get();

    setState(() {
      _messages.addAll(querySnapshot.docs);
      _isLoadingMore = false;
      if (querySnapshot.docs.length < 20 || _messages.length >= 120) {
        _hasMore = false;
      }
    });
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pop(context);
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    await _firestore.collection('chats').add({
      'userName': widget.userName,
      'userProfilePic': widget.userProfilePic,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("hshsha" + data.toString());
    DateTime now = DateTime.now();
    bool isMorning = now.isAfter(t930) && now.isBefore(t1210);
    bool isAfternoonnnn = now.isAfter(t1210) && now.isBefore(t2);
    bool isAfternoon = now.isAfter(t2) && now.isBefore(t430);
    bool isAfterAfternoon = now.isAfter(t430);

    String number =
        isAfternoonnnn || isAfterAfternoon ? widget.number1 : widget.number2;
    String set = isMorning || isAfternoon ? widget.set1 : widget.set2;
    String value = isMorning || isAfternoon ? widget.value1 : widget.value2;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff053b61),
          title: Text(
            'Live Chat',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userProfilePic),
              radius: 20,
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _signOut,
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff053b61),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Live',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.isEmpty ? "" : data['live'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'SET',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.isEmpty
                                  ? "--"
                                  : isMorning
                                      ? data["12:01 PM"][0]["set"]
                                      : data["04:30 PM"][0]["set"] ?? "",
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'VAL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.isEmpty
                                  ? "--"
                                  : isMorning
                                      ? data["12:01 PM"][0]["value"]
                                      : data["04:30 PM"][0]["value"] ?? "",
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Live',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data.isEmpty
                                  ? "--"
                                  : isMorning
                                      ? data["12:01 PM"][0]["number"]
                                      : data["04:30 PM"][0]["number"] ?? "",
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chats')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final messages = snapshot.data!.docs;
                  _messages = messages;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    controller: _scrollController,
                    reverse: true,
                    itemCount: _messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _isLoadingMore
                            ? Center(child: CircularProgressIndicator())
                            : SizedBox.shrink();
                      }
                      final messageData = messages[index];
                      final bool isSentByMe =
                          messageData['userName'] == widget.userName;
                      return ChatBubble(
                        message: messageData['message'],
                        userName: messageData['userName'],
                        isSentByMe: isSentByMe,
                        userProfilePic: messageData['userProfilePic'],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      String message = _messageController.text;
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String userName;
  final bool isSentByMe;
  final String userProfilePic;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.userName, // Add this parameter
    required this.isSentByMe,
    required this.userProfilePic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe)
            CircleAvatar(
              backgroundImage: NetworkImage(userProfilePic),
            ),
          SizedBox(width: 5), // Add space between profile pic and chat bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isSentByMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSentByMe ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isSentByMe)
            SizedBox(width: 5), // Add space between chat bubble and profile pic
          if (isSentByMe)
            CircleAvatar(
              backgroundImage: NetworkImage(userProfilePic),
            ),
        ],
      ),
    );
  }
}
