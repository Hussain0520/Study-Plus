import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class QuizView extends StatefulWidget {
  String code;
  QuizView(this.code);
  @override
  _QuizViewState createState() => _QuizViewState(code);
}

class _QuizViewState extends State<QuizView> {
  String code, answer;
  int marks = 0, aTask = 0, _currentIndex = 0, index = 0;
  Stream quiz;
  Map<int, Color> btn = {
    1: Colors.brown,
    2: Colors.brown,
    3: Colors.brown,
    4: Colors.brown
  };
  List<Color> _color = [Colors.brown, Colors.red];
  List<String> _option = ["option1", "option2", "option3", "option4"];
  _QuizViewState(this.code);
  @override
  void initState() {
    super.initState();
    setState(() {
      quiz = Firestore.instance
          .document("Quiz/$code")
          .collection("quiz")
          .snapshots();
    });
    Firestore.instance
        .document("Quiz/$code")
        .collection("quiz")
        .snapshots()
        .listen((onData) {
      int i = onData.documents.length;
      aTask = i;
    });
    _option.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
        centerTitle: true,
        backgroundColor: Colors.brown,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              score(context);
            },
            child: Text(
              "Submit Quiz",
              style: TextStyle(color: Colors.white, fontSize: 15.0),
            ),
          )
        ],
      ),
      body: _quiz(),
    );
  }

  _quiz() {
    if (quiz != null) {
      return StreamBuilder(
          stream: quiz,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: SpinKitChasingDots(color: Colors.brown));
            }
            String temp = snapshot.data.documents[index].data['option1'];
            answer = temp;
            return Container(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${(index + 1).toString()} / $aTask ",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 130.0),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.data.documents[index].data['Question'],
                      style: TextStyle(fontSize: 25.0),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        ansCheck(
                            snapshot
                                .data.documents[index].data["${_option[0]}"],
                            1);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 40.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            snapshot
                                .data.documents[index].data["${_option[0]}"],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: btn[1],
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        ansCheck(
                            snapshot
                                .data.documents[index].data["${_option[1]}"],
                            2);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 40.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            snapshot
                                .data.documents[index].data["${_option[1]}"],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: btn[2],
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        ansCheck(
                            snapshot
                                .data.documents[index].data["${_option[2]}"],
                            3);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 40.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            snapshot
                                .data.documents[index].data["${_option[2]}"],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: btn[3],
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        ansCheck(
                            snapshot
                                .data.documents[index].data["${_option[3]}"],
                            4);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 40.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            snapshot
                                .data.documents[index].data["${_option[3]}"],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: btn[4],
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ));
          });
    }
  }

  void ansCheck(String ans, int option) {
    print(answer);
    print(ans);
    if (answer == ans) {
      setState(() {
        marks = marks + 1;
        btn[option] = Colors.green;
      });
    } else {
      setState(() {
        btn[option] = Colors.red;
      });
    }
    Future.delayed(Duration(seconds: 2)).then((onValue) {
      nextQ();
    });
  }

  nextQ() {
    if (index < aTask - 1) {
      btn[1] = Colors.brown;
      btn[2] = Colors.brown;
      btn[3] = Colors.brown;
      btn[4] = Colors.brown;
      setState(() {
        index = index + 1;
        _option.shuffle();
      });
    } else {
      score(context);
    }
  }

  score(context) {
    return showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: 500,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage("images/logo.png"),
                      radius: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                    ),
                    Container(
                      height: 160.0,
                      width: 310.0,
                      child: Card(
                        margin: EdgeInsets.all(5.0),
                        color: Colors.brown[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Marks You Scored",
                              style: TextStyle(fontSize: 25.0),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 30.0),
                            ),
                            Text("${marks.toString()}/${aTask.toString()}",
                                style: TextStyle(fontSize: 25.0))
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.brown[100],
          actions: <Widget>[
            FloatingActionButton.extended(
              icon: Icon(Icons.check_circle),
              label: Text("Done"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              backgroundColor: Colors.brown,
            )
          ],
        ));
  }
}
