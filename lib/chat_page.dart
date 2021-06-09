import 'dart:async';
import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'Auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:date_format/date_format.dart';
import 'Model/user.dart';
import 'messageui.dart';
import 'page_navigator.dart';

class ChatPage extends StatefulWidget {

  String groupId;
  final User user;
  PageNavigatorState pageNavigatorState;
  String groupName;
  String image;


  ChatPage({this.groupId, this.user, this.pageNavigatorState, this.groupName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin<ChatPage>{

  TabController tabController;
  @override
  bool get wantKeepAlive => true;
  void initState() {
    super.initState();
    tabController = TabController(length: 1, vsync: this);
  }

  var _isDarkMode;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  final Firestore _firestore = Firestore.instance;
  final AuthService _auth = AuthService();

  bool toggle = false;


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> callback() async {
    String text = messageController.text;
    if (text.length > 0) {
      await _firestore.collection('Groups').document(widget.groupId).collection("messages").add({
        'text': text,
        'email': widget.user.email,
        'date': DateTime.now().toIso8601String().toString(),
        'from': widget.user.email, 
        'uid': widget.user.uid,
        'username': widget.user.userName,
        'picture': widget.user.picture,
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 1200),
      );
    }
    _updateGroupPageText(widget.groupId, widget.user.userName, text, formatDate(DateTime.now(),[M,'-',d,'-',hh]).toString());
  }

  _updateGroupPageText(String groupid, String lastUser, String lastMessage, String time){
    if(lastMessage.length > 20){
      lastMessage = lastMessage.substring(0, 20)+ "...";
    }
    Firestore.instance.collection('Groups').document(groupid).updateData({
      'lastUser': lastUser, 
      'time':time,
      'timestamp': FieldValue.serverTimestamp(),
      'lastMessage':lastMessage
    });
  }

  DocumentReference getGroup(){
    return _firestore.collection('Groups').document(widget.groupId);
  }

  Widget build(BuildContext context) {

    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    User user = Provider.of<User>(context);

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color:  _isDarkMode ? Color(0xffffffff) : Color(0xff000000)),
            elevation: 0.0,
            backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
          ),
          body: Container(
            child: (){
              if(widget.groupId == null){
                return Container(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: FractionalOffset.topCenter,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0.0,0.10,0.0,5.0),
                          padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,0.0),
                          decoration: BoxDecoration(
                            color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.all(20.0),
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: _isDarkMode ? Colors.white12 : Color(0xfff1f3f4),
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(50.0),
                                child: Lottie.asset(
                                  'assets/writing.json',
                                  repeat: true,
                                  reverse: true,
                                  animate: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8, right: 10, left: 10),
                                child: Text(
                                  "Select a spot to make a chatbox contribution",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white : Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Start by choosing one",
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white54 : Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Flexible(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore.collection('Groups').document(widget.groupId).collection("messages").orderBy('date').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData){
                              return Center(
                                child: Container(
                                  padding: const EdgeInsets.all(2.8),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.8,
                                    valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffffffff)),
                                  ),
                                ),
                              );
                            }
                            List<DocumentSnapshot> docs = snapshot.data.documents;
                            List<Widget> messages = docs.map((doc) {
                              if(doc['uid'] == null){
                                return MessageUI(
                                  user: doc['from'],
                                  text: doc['text'],
                                  picture: null,
                                  date: doc['date'],
                                  isMe: user.email == doc['email'],
                                );
                              }
                              return MessageUI(
                                text: doc['text'],
                                user: doc['username'] != null ? doc['username'] : "noUsername",
                                picture: doc['picture'],
                                date: doc['date'],
                                isMe: user.email == doc['email'],
                              );
                            }).toList();

                            return CupertinoScrollbar(
                                isAlwaysShown: true,
                                child: ListView(
                                    padding: EdgeInsets.fromLTRB(0.0,255.0,0.0,85.0),
                                    controller: scrollController,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    children: messages.reversed.toList(),
                                    reverse: true
                                )
                            );
                          }
                      ),
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                          border: Border(
                              top: BorderSide(
                                color: _isDarkMode ? Colors.white30 : Colors.black12,
                                width: 0.7,
                              )
                          ),
                        ),
                        padding: EdgeInsets.all(0.0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                height: 45,
                                margin: EdgeInsets.fromLTRB(10.0,0.0,10.0,5.0),
                                padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,5.0),
                                decoration: BoxDecoration(
                                  color: _isDarkMode ? Colors.white10 : Color(0xfff1f3f4),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: TextField(
                                  controller: messageController,
                                  onSubmitted: (value) => callback(),
                                  decoration: InputDecoration(
                                    labelText: 'Lets talk about it...',
                                    labelStyle: TextStyle(
                                      color: _isDarkMode ? Colors.white70 : Colors.black87,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.0,8.0,0.0,0.0),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: callback,
                              child: Container(
                                  height: 45,
                                  width: 45,
                                  margin: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.white10 : Color(0xfff1f3f4),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    child: Icon(
                                        Ionicons.paper_plane,
                                        color: _isDarkMode ? Color(0xff2663FF) : Color(0xff2663FF),
                                        size: 26
                                    ),
                                  )
                              ),
                            ),
                            GestureDetector(
                                child: toggle
                                    ?
                                Container(
                                    height: 45,
                                    width: 45,
                                    margin: const EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: _isDarkMode ? Colors.white10 : Color(0xfff1f3f4),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(EvaIcons.heart, color: Color(0xffed2e61), size: 28)
                                )
                                    :
                                Container(
                                  height: 45,
                                  width: 45,
                                  margin: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.white10 : Color(0xfff1f3f4),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Lottie.asset(
                                    'assets/heart.json',
                                    repeat: false,
                                    reverse: true,
                                    animate: true,
                                  ),
                                ),
                                onDoubleTap: () {
                                  setState(() {
                                    toggle = !toggle;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            }(),
          )
      )
    );
  }


  void refresh(){
    sleep(const Duration(seconds: 1));
    setState(() {});
  }
}


