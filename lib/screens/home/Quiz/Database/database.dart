import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Database{
  static Future<void> createQuiz(Map<String,String> data,code)
  async{
    await Firestore.instance.collection("Quiz")
        .document("$code").setData(data);
  }
  static Future<void> uploadQuestion(Map data,code)
 async {
    await Firestore.instance.collection("Quiz")
        .document("$code").collection("quiz")
        .document().setData(data);
  }
}