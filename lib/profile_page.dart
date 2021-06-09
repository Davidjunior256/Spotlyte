import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:video_chat/Auth/auth.dart';
import 'package:video_chat/Model/user.dart';
import 'package:video_chat/edit_profile.dart';


class ProfilePage extends StatefulWidget {

  final User user;

  ProfilePage(this.user);


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var _isDarkMode;

  final AuthService _auth = AuthService();

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
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
        appBar: AppBar(
          iconTheme: IconThemeData(color:  _isDarkMode ? Color(0xffffffff) : Color(0xff000000)),
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: _isDarkMode ? Color(0xff000000) : Color(0xffffffff),
        ),
        body: Column(
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
              padding: const EdgeInsets.all(5.0),
              child: _isDarkMode
                  ? Icon(
                  Ionicons.person,
                  color: Colors.white60,
                  size: 80)
                  : Lottie.asset(
                'assets/profile.json',
                repeat: true,
                reverse: true,
                animate: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, right: 10, left: 10),
              child: Text(
                "Username",
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Edit your bio",
                style: TextStyle(
                  color: _isDarkMode ? Colors.white54 : Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150,
                  height: 45,
                  margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Color(0xff2663FF) : Color(0xff2663FF),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    color: _isDarkMode ? Color(0xff2663FF) : Color(0xff2663FF),
                    textColor: Colors.white,
                    onPressed: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => EditProfile(),
                        ),
                      );
                    },
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
