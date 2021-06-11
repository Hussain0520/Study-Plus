//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studyplus/screens/home/functions/teachersonly.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('user');

  Future updateUserData(String name, String email, String role) async {
    return await userCollection.document(uid).setData({
      'Name': name,
      'Email': email,
      'Role': role,
    });
  }

  authorizeAccess(BuildContext context) {
//    try {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance
          .collection('user')
          .where('Email', isEqualTo: user.email)
          .getDocuments()
          .then((uid) {
//        print(uid.documents[0].data['Role']);
        if (uid.documents[0].exists) {
          if (uid.documents[0].data['Role'] == 'TEACHER') {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => TeacherPage()));
          } else {
            print('Not Authorized');
          }
        }
      });
    });
//    } catch (e) {
//      print(e);
//    }
  }
}
