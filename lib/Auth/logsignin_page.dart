import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';


class LogsignIn extends StatelessWidget {
  static const String id = "HOMESCREEN";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xffffffff),
              ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: 120,
                        margin: const EdgeInsets.only(top: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xff2663FF),
                          shape: BoxShape.rectangle,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Spotlight",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.1
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Welcome to Spotlight",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 0.1,
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Join your friends who use Vixen to talk with communities & friends",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SignUpButtons(
                  text: 'Register',
                  callback: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Register(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 5.0),
                SigninButtons(
                  text:  'Login',
                  callback: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class SigninButtons extends StatelessWidget {

  final VoidCallback callback;
  final String text;

  const SigninButtons({Key key, this.callback, this.text}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return  Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
          color: Color(0xffe3e5e8),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: callback,
        color: Color(0xffe3e5e8),
        textColor: Colors.white,
        child: Text(
          'Log In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SignUpButtons extends StatelessWidget {

  final VoidCallback callback;
  final String text;

  const SignUpButtons({Key key, this.callback, this.text}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
          color: Color(0xff2663FF),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: callback,
        color: Color(0xff2663FF),
        textColor: Colors.white,
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
