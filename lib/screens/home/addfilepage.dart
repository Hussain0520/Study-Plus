import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyplus/screens/home/Quiz/Createquiz.dart';
import 'package:studyplus/screens/home/functions/teachersonly.dart';
import 'functions/usermanagement.dart';

class AddFile extends StatefulWidget {
  String className;
  String docId;
  String code;
  AddFile(String className, String docId, String code) {
    this.className = className;
    this.docId = docId;
    this.code = code;
  }
  @override
  _AddFileState createState() => _AddFileState(className, docId, code);
}

class _AddFileState extends State<AddFile> {
  var userM = UserManagement();
  TextEditingController _title = TextEditingController();
  TextEditingController _classcode = TextEditingController();
  File file;
  String className;
  String docId;
  String code;
  String quizT;
  String quizD;
  Stream assignment;
  Stream video;
  int num = 0;
  bool load = true;
  ProgressDialog progress;
  _AddFileState(this.className, this.docId, this.code);

  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      userM.loadAssignment(className, docId, uid).then((result) {
        setState(() {
          assignment = result;
        });
      });
      userM.loadVideo(className, docId, uid).then((result) {
        setState(() {
          video = result;
        });
      });
      userM.loadQuiz(code).get().then((snapshot) {
        setState(() {
          quizD = snapshot.data['QuizDesc'];
          quizT = snapshot.data['QuizTitle'];
          load = false;
        });
      });
    });
  }

  _addAssignment(BuildContext context) async {
    progress = ProgressDialog(context, type: ProgressDialogType.Download);
    progress.style(
      message: "Uploading File",
      progressWidget: LinearProgressIndicator(),
    );
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Assignment"),
            content: SizedBox(
                height: 140.0,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _title,
                      decoration:
                          InputDecoration(labelText: "Assignment-Title"),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        String title = _title.text;
                        file = await FilePicker.getFile(
                            type: FileType.custom, allowedExtensions: ['pdf']);
                        userM.addAssignment(
                            className, title, file, docId, context);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: <Widget>[
                          Text("Upload Assignment"),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Icon(Icons.assignment)
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                        Text("Only Pdf File"),
                      ],
                    )
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              )
            ],
          );
        });
  }

  _addVideo(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Video Lecture"),
            content: SizedBox(
                height: 120.0,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(labelText: "Video-Title"),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        String title = _title.text;
                        file = await FilePicker.getFile(type: FileType.video);
                        userM.addVideo(className, title, file, docId);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: <Widget>[
                          Text("Uplaod Video"),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                          ),
                          Icon(Icons.personal_video)
                        ],
                      ),
                    )
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK")),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown[400],
            title: Text(className),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherPage()),
                );
              },
            ),
            bottom: TabBar(tabs: <Widget>[
              Tab(
                icon: Icon(Icons.assignment),
                text: "Assignment",
              ),
              Tab(icon: Icon(Icons.question_answer), text: "Quiz"),
              Tab(icon: Icon(Icons.personal_video), text: "Video"),
            ]),
          ),
          body: TabBarView(
            children: <Widget>[
              Scaffold(
                body: _assignment(),
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Colors.brown[400],
                  icon: Icon(Icons.assignment),
                  label: Text("Upload Assignment"),
                  onPressed: () {
                    _addAssignment(context);
                  },
                ),
              ),
              Scaffold(
                body: load
                    ? Center(child: SpinKitChasingDots(color: Colors.brown))
                    : SizedBox(
                        height: 200.0,
                        child: Card(
                          color: Colors.grey,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/logo.png"),
                                ),
                                title: Text(quizT),
                                subtitle: Text(quizD),
                              ),
                              Column(
                                children: <Widget>[
                                  Text("No. of Student Atempt"),
                                  Text(num.toString()),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Colors.brown[400],
                  icon: Icon(Icons.question_answer),
                  label: Text("Make Quiz"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateQuiz(code)));
                  },
                ),
              ),
              Scaffold(
                body: _video(),
                floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Colors.brown[400],
                  icon: Icon(Icons.personal_video),
                  label: Text("Upload Video"),
                  onPressed: () {
                    _addVideo(context);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _assignment() {
    if (assignment != null) {
      return StreamBuilder(
        stream: assignment,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: SpinKitChasingDots(color: Colors.brown));
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Assignment",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(snapshot.data.documents[index].data['Title']),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.picture_as_pdf,
                          size: 50.0, color: Colors.grey[500]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                    ),
                  ],
                ),
                color: Colors.white70,
              );
            },
          );
        },
      );
    } else {
      return Center(child: SpinKitChasingDots(color: Colors.brown));
    }
  }

  Widget _video() {
    if (video != null) {
      return StreamBuilder(
        stream: video,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: SpinKitChasingDots(color: Colors.brown));
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Video Lec",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(snapshot.data.documents[index].data['Title']),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.personal_video,
                        size: 50.0,
                        color: Colors.grey[500],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                    ),
                  ],
                ),
                color: Colors.white70,
              );
            },
          );
        },
      );
    } else {
      return Center(child: SpinKitChasingDots(color: Colors.brown));
    }
  }
}
