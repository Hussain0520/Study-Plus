import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studyplus/screens/home/Quiz/Quizview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:studyplus/screens/home/functions/usermanagement.dart';

class ClassFile extends StatefulWidget {
  String className;
  String classCode;
  ClassFile(className, classCode) {
    this.className = className;
    this.classCode = classCode;
  }
  @override
  _ClassFileState createState() => _ClassFileState(className, classCode);
}

class _ClassFileState extends State<ClassFile> {
  String className, classCode, name, docs, Student, quizD, quizT;
  Stream assignment, video, quiz, student;
  bool load = true;
  List<int> selectedRadio;
  int aTask;
  int vTask;

  var userM = UserManagement();
  _ClassFileState(this.className, this.classCode);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance
        .collection("Classes")
        .where("code", isEqualTo: classCode)
        .getDocuments()
        .then((doc) {
      setState(() {
        assignment = Firestore.instance
            .document("Classes/${doc.documents[0].documentID}")
            .collection("Assignments")
            .snapshots();
        video = Firestore.instance
            .document("Classes/${doc.documents[0].documentID}")
            .collection("video")
            .snapshots();
        student = Firestore.instance
            .document("Classes/${doc.documents[0].documentID}")
            .collection("Student")
            .snapshots();
        Firestore.instance
            .document("Classes/${doc.documents[0].documentID}")
            .collection("Assignments")
            .snapshots()
            .listen((onData) {
          int i = onData.documents.length;
          aTask = i;
        });
        Firestore.instance
            .document("Classes/${doc.documents[0].documentID}")
            .collection("video")
            .snapshots()
            .listen((onData) {
          int j = onData.documents.length;
          vTask = j;
        });
        docs = doc.documents[0].data['Teacher'];
      });
      Firestore.instance.document("user/$docs").get().then((onValue) {
        setState(() {
          String _name = onValue.data['Name'];
          name = _name;
        });
      });
    });

    userM.loadQuiz(classCode).get().then((snapshot) {
      setState(() {
        quizD = snapshot.data['QuizDesc'];
        quizT = snapshot.data['QuizTitle'];
        load = false;
      });
    });
  }

  Future<void> _launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(className),
          centerTitle: true,
          backgroundColor: Colors.brown,
          bottom: TabBar(tabs: <Widget>[
            Tab(
              icon: Icon(Icons.assignment),
              text: "Assignments",
            ),
            Tab(
              icon: Icon(Icons.question_answer),
              text: "Quiz",
            ),
            Tab(
              icon: Icon(Icons.personal_video),
              text: "Video",
            ),
            Tab(
              icon: Icon(Icons.portrait),
              text: "Class",
            ),
          ]),
        ),
        body: TabBarView(
          children: <Widget>[
            Scaffold(
              body: _assignment(),
            ),
            Scaffold(
                body: load
                    ? Center(child: SpinKitChasingDots(color: Colors.brown))
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizView(classCode)));
                        },
                        child: SizedBox(
                          height: 150.0,
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
                              ],
                            ),
                          ),
                        ),
                      )),
            Scaffold(
              body: _video(),
            ),
            Scaffold(
              body: _class(),
            )
          ],
        ),
      ),
    );
  }

  Widget _assignment() {
    if (assignment != null) {
      return StreamBuilder(
        stream: assignment,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: SpinKitChasingDots(
              color: Colors.brown,
            ));
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
                    Container(
                      height: 40.0,
                      child: RaisedButton(
                        onPressed: () async {
                          String filepath = "$docs/$className";
                          StorageReference store = FirebaseStorage.instance
                              .ref()
                              .child(filepath)
                              .child("Assignments")
                              .child(
                                  "${snapshot.data.documents[index].data['Title']}.pdf");
                          String path = await store.getDownloadURL();
                          _launchUniversalLinkIos(path.toString());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Download"),
                            Icon(Icons.file_download),
                          ],
                        ),
                      ),
                    )
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
            return Center(
                child: SpinKitChasingDots(
              color: Colors.brown,
            ));
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
                    Container(
                      height: 40.0,
                      child: RaisedButton(
                        onPressed: () async {
                          String filepath = "$docs/$className";
                          StorageReference store = FirebaseStorage.instance
                              .ref()
                              .child(filepath)
                              .child("Videos")
                              .child(
                                  "${snapshot.data.documents[index].data['Title']}");
                          String path = await store.getDownloadURL();
                          _launchUniversalLinkIos(path.toString());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Download"),
                            Icon(Icons.file_download),
                          ],
                        ),
                      ),
                    )
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

  Widget _class() {
    if (name != null) {
      return ListView(
        children: <Widget>[
          Center(
            child: Text(
              "Class Details",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
          ),
          Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                color: Colors.brown[100],
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Teacher Details",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                          backgroundImage: AssetImage('images/profile.png')),
                      title: Text(name),
                      subtitle: Text("Class Teacher"),
                    ),
                    Column(
                      children: <Widget>[
                        Text("No. of Assignmetns"),
                        Text(aTask.toString()),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Column(
                      children: <Widget>[
                        Text("No. of Video lec"),
                        Text(vTask.toString()),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10.0),
          ),
          Center(
            child: Text(
              "Student List",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          _student()
        ],
      );
    }
    return Center(child: SpinKitChasingDots(color: Colors.brown));
  }

  _student() {
    if (student != null) {
      return StreamBuilder(
          stream: student,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: SpinKitChasingDots(color: Colors.brown));
            }
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Firestore.instance
                      .document(
                          "user/${snapshot.data.documents[index].data['uid']}")
                      .snapshots()
                      .listen((onData) {
                    setState(() {
                      Student = onData.data['Name'];
                    });
                  });
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("images/profile.png"),
                      ),
                      title:
                          Student != null ? Text(Student) : Text("Loading...."),
                      subtitle: Text("STUDENT"),
                    ),
                  );
                });
          });
    }
  }
}
