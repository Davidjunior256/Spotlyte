import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_chat/homepage.dart';
import 'package:video_chat/profile_page.dart';
import 'package:video_chat/setting_screen.dart';
import 'chat_page.dart';
import 'package:provider/provider.dart';
import 'Model/user.dart';


class PageNavigator extends StatefulWidget{
  static const String id = "HOMESCREEN";

  String groupId;

  PageNavigator({this.groupId});

  @override
  PageNavigatorState createState() => PageNavigatorState();
}

class PageNavigatorState extends State<PageNavigator> {

  bool toggle = false;

  var _isDarkMode;

  String selectedGroupID;
  String selectedGroupName;

  PageController controller = PageController(initialPage: 1);

  Firestore _firestore = Firestore.instance;

  String newUsername;
  String newImageURL;

  bool dialogueUp = false;

  @override
  Widget build(BuildContext context) {

    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    User user = Provider.of<User>(context);

    _firestore.collection('Users').document(user.uid).get().then( (doc) {
      if(doc.exists && doc['username'] != null){
        user.userName = doc['username'];
        user.picture = doc['picture'];
      } else if(!dialogueUp){
        dialogueUp = true;
        print("user does not exist");
        showModalBottomSheet(
          backgroundColor: Colors.black.withOpacity(0.1),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 1, // half screen on load
              maxChildSize: 1, // full screen on scroll
              minChildSize: 0.25,
              builder: (BuildContext context,
                  ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(0),
                      topRight: const Radius.circular(0),
                    ),
                  ),
                  padding: EdgeInsets.all(0),
                  child: ListView(children: <Widget>[
                    SizedBox(height: 25),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20, top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(2.5),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xfff1f3f4),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.close,
                                      color: Color(0xff2663FF),
                                      size: 28.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Padding(
                                padding: EdgeInsets.only(left: 5, top: 10),
                                child: GestureDetector(
                                  child: Text(
                                    'What should everyone call you?',
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.black12),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: GestureDetector(
                        child: Text(
                          'Create your username',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(15.0,8.0,0.0,0.0),
                          hintText: 'Enter Username',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (value){
                          newUsername = value;
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: 50.0, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        shape: BoxShape.rectangle,
                      ),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Color(0xff2663FF),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Text('Create Username',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400
                            )
                        ),
                        onPressed: (){
                          _firestore.collection("Users").document(user.uid).setData({
                            'username': newUsername,
                            'picture': newImageURL,
                          });
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                          user.userName = newUsername;
                          user.picture = newImageURL;
                          User u = Provider.of<User>(context);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(height: 70),
                  ]),
                );
              },
            );
          },
        );
      }
    });

    return  Scaffold(
      body: PageView(
        pageSnapping: true,
        allowImplicitScrolling: true,
        scrollDirection: Axis.horizontal,
        controller: controller,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 10, left: 0, right: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
              shape: BoxShape.rectangle,
            ),
            child: Stack(
              children: <Widget>[
                ProfilePage(user),
                Align(
                  alignment: FractionalOffset.topCenter,
                  child: Container(
                    height: 70,
                    margin: const EdgeInsets.only(top: 10, left: 0, right: 0),
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,0.0),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                        color: _isDarkMode ? Colors.white30 : Colors.black12,
                        width: 0.7,
                        )
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => SettingScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                    EvaIcons.settingsOutline,
                                    color: _isDarkMode ? Colors.white : Colors.black,
                                    size: 26
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                              borderRadius: BorderRadius.circular(7.0),
                              shape: BoxShape.rectangle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Profile",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: _isDarkMode ? Color(0xffffffff) : Color(0xff000000),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Color(0xfff1f3f4),
                          radius: 5,
                          onTap: () {
                            controller.animateToPage(1, duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.4,
                              ),
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                    EvaIcons.arrowIosForward,
                                    color: _isDarkMode ? Color(0xffffffff) : Color(0xff000000),
                                    size: 26
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 0, right: 0),
            padding: EdgeInsets.fromLTRB(2.0,0.0,2.0,0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
              shape: BoxShape.rectangle,
            ),
            child: Stack(
              children: <Widget>[
                HomePage(this, user, widget.groupId),
                Align(
                  alignment: FractionalOffset.topCenter,
                  child: Container(
                    height: 70,
                    margin: const EdgeInsets.only(top: 10, left: 0, right: 0),
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,0.0),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                      border: Border(
                          bottom: BorderSide(
                            color: _isDarkMode ? Colors.white30 : Colors.black12,
                            width: 0.7,
                          )
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          splashColor: Color(0xfff1f3f4),
                          radius: 5,
                          onTap: () {
                            controller.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.4,
                              ),
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                    EvaIcons.menuOutline,
                                    color: _isDarkMode ? Color(0xffffffff) : Color(0xff000000),
                                    size: 26
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 0),
                            decoration: BoxDecoration(
                              color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                              borderRadius: BorderRadius.circular(7.0),
                              shape: BoxShape.rectangle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Spotlight",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: _isDarkMode ? Color(0xffffffff) : Color(0xff000000),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
//                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Color(0xfff1f3f4),
                          radius: 5,
                          onTap: () {
                            controller.animateToPage(2, duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.4,
                              ),
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                    EvaIcons.arrowIosForward,
                                    color: _isDarkMode ? Color(0xffffffff) : Color(0xff000000),
                                    size: 26
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: 0, right: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
              color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
              shape: BoxShape.rectangle,
            ),
            child: Stack(
              children: <Widget>[
                ChatPage(
                  groupId: selectedGroupID,
                  groupName: selectedGroupName,
                  user: user,
                  pageNavigatorState: this,
                ),
                Align(
                  alignment: FractionalOffset.topLeft,
                  child: Container(
                    height: 70,
                    margin: const EdgeInsets.only(top: 10, left: 0, right: 0),
                    padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,0.0),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                      border: Border(
                          bottom: BorderSide(
                            color: _isDarkMode ? Colors.white30 : Colors.black12,
                            width: 0.7,
                          )
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          splashColor: Color(0xfff1f3f4),
                          radius: 5,
                          onTap: () {
                            controller.animateToPage(1, duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(0.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.4,
                              ),
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                    EvaIcons.arrowIosBack,
                                    color: _isDarkMode ? Color(0xffffffff) : Color(0xff000000),
                                    size: 26
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
                              borderRadius: BorderRadius.circular(7.0),
                              shape: BoxShape.rectangle,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(0.0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                          EvaIcons.heart,
                                          color: Color(0xffed2e61),
                                          size: 18
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Live ChatBox",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: _isDarkMode ? Color(0xffffffff) : Color(0xff000000),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  // Used in other pages to set the selected page of the PageView
  void setPage(int page){
    controller.animateToPage(page, duration: Duration(milliseconds: 480), curve: Curves.bounceInOut);
  }

}

