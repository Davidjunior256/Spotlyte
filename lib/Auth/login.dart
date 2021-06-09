import 'package:flutter/material.dart';
import 'auth.dart';

//LOGIN
class Login extends StatefulWidget {
  static const String id = "LOGIN";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool passwordVisible =false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xff000000)),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          'Login',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        children:<Widget>[
          SingleChildScrollView(
            child:Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              //Using the Form widget to create a validation for when the user inputs data
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 28.0),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      decoration: BoxDecoration(
                        color: Color(0xffe3e5e8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Color(0xff2663FF),
                        validator: (val) => val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val){
                          setState(() => email = val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: Colors.black12)),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      decoration: BoxDecoration(
                        color: Color(0xffe3e5e8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextFormField(
                        obscureText: !passwordVisible,
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                        cursorColor: Color(0xff2663FF),
                        validator: (val) => val.length < 3 ? 'Enter Password' : null,
                        onChanged: (val){
                          //making the password variable be the value entered
                          setState(() => password = val);
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: passwordVisible? Colors.black87: Colors.grey,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              borderSide: BorderSide(color: Colors.black12)),
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 55,
                      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        onPressed: () async{
                          if (_formKey.currentState.validate()){
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                            if(result == null){
                              setState(() => error = 'email password incorrect');
                            }
                            else{
                              Navigator.pop(context);
                            }
                          }
                        },
                        color: Color(0xff2663FF),
                        textColor: Colors.white,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "By Signing in, you agree to our Terms of Use & Privacy Policy",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      error, 
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
