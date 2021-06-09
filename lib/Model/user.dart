import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User{
  String email;
  final String uid;
  String userName;
  String picture;
  final String displayName;
  final String bio;


  User({
    this.uid,
    this.email,
    this.userName,
    this.picture,
    this.displayName,
    this.bio,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc['uid'],
      email: doc['email'],
      userName: doc['userName'],
      picture: doc['picture'],
      displayName: doc['displayName'],
      bio: doc['bio'],
    );
  }
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = new DateTime.now();
  final dt = DateTime(now.day, tod.hour, tod.minute);
  final format = DateFormat.d();//"6:00 AM"
  return format.format(dt);
}
