import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UserManagement {
  ProgressDialog progress;

  //Class_DataBase
  //Creating Class
  storeNewClass(cname, code, context) {
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      Firestore.instance
          .collection("$uid")
          .document()
          .setData({"class": cname, "code": code});
      Firestore.instance
          .collection("Classes")
          .document()
          .setData({"ClassName": cname, "code": code, "Teacher": uid});
    });
  }

  addNewClass(classCode, context) {
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      Stream datas = Firestore.instance
          .collection("Classes")
          .where("code", isEqualTo: classCode)
          .snapshots();
      datas.listen((onData) {
        Firestore.instance
            .collection("user")
            .document("$uid")
            .collection("Class")
            .document()
            .setData({
          "className": onData.documents[0].data['ClassName'],
          "code": classCode,
          "Teacher": onData.documents[0].data['Teacher']
        });
        Firestore.instance.collection("Classes")
        .where("code" , isEqualTo: classCode)
        .getDocuments().then((docs){
          Firestore.instance.document("Classes/${docs.documents[0].documentID}")
              .collection("Student").document().setData({"uid":uid});
        });
      });
    });
  }

  //Fetching CLass Details From FireStore
  loadClassList(uid) async {
    return Firestore.instance.collection("$uid").snapshots();
  }

  //Deleting Class
  deleteClass(docId) {
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      Firestore.instance.collection("$uid").document(docId).delete();
    });
  }

  //Add Assignment to FireStore
  addAssignment(
      String className, String title, File fileUrl, docId, context) async {
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      Firestore.instance
          .collection("$uid")
          .document(docId)
          .collection('Assignments')
          .document()
          .setData({"Title": title, "Url": fileUrl.toString()});

      String filepath = "$uid/$className";
      StorageReference store = FirebaseStorage.instance
          .ref()
          .child(filepath)
          .child("Assignments")
          .child("$title.pdf");
      StorageUploadTask task = store.putFile(fileUrl);
      Firestore.instance
          .collection("Classes")
          .where("ClassName", isEqualTo: className)
          .getDocuments()
          .then((doc) {
        Firestore.instance
            .document("Classes/${doc.documents[0].documentID}")
            .collection("Assignments")
            .document()
            .setData({"Title": title, "Assignment-url": fileUrl.toString()});
      });
    });
  }

  loadAssignment(className, docId, uid) async {
    return Firestore.instance
        .collection("$uid")
        .document(docId)
        .collection('Assignments')
        .snapshots();
  }

  addVideo(String className, String title, File fileUrl, docId) async {
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      Firestore.instance
          .collection("$uid")
          .document(docId)
          .collection('Videos')
          .document()
          .setData({"Title": title, "video url": fileUrl.toString()});

      String filepath = "$uid/$className";
      StorageReference store = FirebaseStorage.instance
          .ref()
          .child(filepath)
          .child("Videos")
          .child("$title");
      StorageUploadTask task = store.putFile(fileUrl);
    });
    Firestore.instance
        .collection("Classes")
        .where("ClassName", isEqualTo: className)
        .getDocuments()
        .then((doc) {
      Firestore.instance
          .document("Classes/${doc.documents[0].documentID}")
          .collection("video")
          .document()
          .setData({"Title": title, "video url": fileUrl.toString()});
    });
  }

  loadVideo(className, docId, uid) async {
    return Firestore.instance
        .collection("$uid")
        .document(docId)
        .collection('Videos')
        .snapshots();
  }

  //ProFile Information
  userInfo(name, email, clg, country, contact, context) {
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      Firestore.instance.collection('/user').document('$uid').updateData({
        'Name': name,
        'Email': email,
        'college': clg,
        'Country': country,
        'contact': contact
      });
    });
  }

  profilePic(file, name) {
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      StorageReference store = FirebaseStorage.instance
          .ref()
          .child("user_profiles")
          .child("$uid")
          .child("$name");
      StorageUploadTask task = store.putFile(file);
    });
  }

  showProfile(uid, name) async {
    StorageReference store = FirebaseStorage.instance
        .ref()
        .child("user_profiles")
        .child("$uid")
        .child("$name");
    final image = store.getDownloadURL();
    return image;
  }

  //User Profile
  userData(docs) {
    print(docs);
    return Firestore.instance.document('/user/$docs');
  }
  loadQuiz(code)
   {
    return Firestore.instance
        .document("Quiz/$code");

  }
  loadQuizData(code)
  {
    return Firestore.instance.document("Quiz/$code").collection("quiz").snapshots();
  }
}
