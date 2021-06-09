import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class NewPost extends StatefulWidget {

  NewPost({Key key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  var isDarkTheme;

  Firestore _firestore = Firestore.instance;
  File _image;
  String groupName;
  String groupName1;
  String _url;

  final formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkTheme ? Color(0xff000000) : Color(0xffffffff),
      appBar: AppBar(
        iconTheme: IconThemeData(color:  isDarkTheme ? Color(0xffffffff) : Color(0xff000000)),
        automaticallyImplyLeading: true,
        title: Text(
          "Create spot",
          style: TextStyle(
            color: isDarkTheme ? Color(0xffffffff) : Color(0xff000000),
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0.5,
        backgroundColor: isDarkTheme ? Color(0xff000000) : Color(0xffffffff),
        actions: [
          InkWell(
            splashColor: Color(0xfff1f3f4),
            radius: 5,
            onTap: uploadImage,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDarkTheme ? Color(0xff000000) : Color(0xffffffff),
                borderRadius: BorderRadius.circular(5.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 16),
              child: Text(
                'Done',
                style: TextStyle(
                  color:  isDarkTheme ? Color(0xff2663FF) : Color(0xff2663FF),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(25),
            child: Form(
                key: formKey,
                child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        decoration: BoxDecoration(
                          color: isDarkTheme ? Colors.white10 : Color(0xfff1f3f4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(color:  isDarkTheme ? Colors.white : Colors.black),
                          cursorColor: Color(0xff2663FF),
                          validator: (value) {
                            return value.isEmpty ? 'Description is required' : null;
                          },
                          onSaved: (value) {
                            return groupName = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'What its going to be?',
                            hintStyle: TextStyle(
                              color:  isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
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
                          color: isDarkTheme ? Colors.white10 : Color(0xfff1f3f4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(color:  isDarkTheme ? Colors.white : Colors.black),
                          cursorColor: Color(0xff2663FF),
                          validator: (value) {
                            return value.isEmpty ? 'Description is required' : null;
                          },
                          onSaved: (value) {
                            return groupName1 = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Schedule',
                            hintStyle: TextStyle(
                              color:  isDarkTheme ? Colors.white : Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                borderSide: BorderSide(color: Colors.black12)),
                            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                     _image != null
                      ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      ))
                      : GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      decoration: BoxDecoration(
                          color: isDarkTheme ? Colors.white10 : Color(0xfff1f3f4),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                              Ionicons.images_outline,
                              color: isDarkTheme ? Colors.white : Colors.black,
                              size: 40
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add high quality image',
                            style: TextStyle(
                              color: isDarkTheme ? Colors.white70 : Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                      SizedBox(
                       height: 10,
                  ),
                ])
            )
        ),
      ),
    );
  }


  bool formValidateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadImage() async {
    if (formValidateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance.ref().child("post images");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(_image);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      _url = imageUrl.toString();
      await saveToDatabase(_url);
    }
  }

  Future saveToDatabase(url) async {
    var timeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(timeKey);
    String time = formatTime.format(timeKey);
    Firestore _firestore = Firestore.instance;

    var data = {"image": _url, "groupName": groupName,  "groupName1": groupName1, "date": date, "time": time};

    _firestore.collection("Groups").add(data);
    SnackBar snackbar = SnackBar(content: Text("Successfully posted!"));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Future getImage() async {
    final image =  await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
      } else {
        print('No image selected.');
      }
    });
  }
}
