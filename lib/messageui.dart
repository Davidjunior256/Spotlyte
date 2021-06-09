import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';


class MessageUI extends StatelessWidget {
  final String user;
  final String text;
  final String picture;
  final String date;

  bool isMe;

  MessageUI({this.user, this.text, this.picture, this.date, this.isMe});

  var _isDarkMode;

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Container msg = Container(
      margin: EdgeInsets.only(
          top: 4.0,
          bottom: 1.2,
          left: 10
      ),
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
      width: MediaQuery.of(context).size.width * 0.60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: isMe
            ? BorderRadius.circular(15)
            : BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isMe ?
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                user == null
                ? Text(
                  "User",
                  style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                  ),
                )
                : Text(
                  user,
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.white10 : Color(0xfff1f3f4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'You',
                        style: TextStyle(
                          color: _isDarkMode ? Colors.white54 : Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ) :
          user == null
              ? Text(
            "User",
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          )
              : Text(
            user,
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
    if (isMe) { // to print user's messages on right side
      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(0.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      picture == null
                      ? Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 50,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: _isDarkMode ? Color(0xff2663FF) : Color(0xff2663FF),
                          shape: BoxShape.rectangle,
                        ),
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Ionicons.person,
                              color: _isDarkMode ? Colors.white : Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      )
                      : Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 50,
                        width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(picture),
                              fit: BoxFit.cover,
                            ),
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.all(0.0),
                          child: msg
                      ),
                    ]
                )
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(0.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    picture == null
                        ? Container(
                      margin: const EdgeInsets.all(0.0),
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Colors.white10 : Color(0xfff1f3f4),
                        borderRadius: BorderRadius.circular(7),
                        shape: BoxShape.rectangle,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Ionicons.person,
                            color: _isDarkMode ? Colors.white54 : Colors.black26,
                            size: 20,
                          ),
                        ],
                      ),
                    )
                        : Container(
                        margin: const EdgeInsets.all(0.0),
                        height: 50,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(picture),
                            fit: BoxFit.cover,
                          ),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.all(0.0),
                        child: msg
                    ),
                  ]
              )
          ),
        ],
      ),
    );
  }
}
