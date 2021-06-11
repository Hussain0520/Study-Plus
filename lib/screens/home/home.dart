import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studyplus/screens/home/classfilepage.dart';
import 'package:studyplus/screens/home/functions/aboutUs.dart';
import 'package:studyplus/screens/home/functions/calender.dart';
import 'package:studyplus/screens/home/functions/profile.dart';
import 'package:studyplus/screens/home/functions/teachersonly.dart';
import 'package:studyplus/screens/login.dart';
import 'package:studyplus/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:studyplus/screens/home/functions/usermanagement.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  var userM = UserManagement();
  TextEditingController _classcode = TextEditingController();
  ProgressDialog progress;
  String demo;
  String role;
  final _formKey = GlobalKey<FormState>();
  Stream info;
  String error = '';
  String error1;
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      setState(() {
        info = Firestore.instance
            .collection("user")
            .document("$uid")
            .collection("Class")
            .snapshots();
      });
      Firestore.instance.document("user/$uid").get().then((onValue) {
        if (onValue.data['Role'] == "Teacher") {
          print("welcome");
        }
      });
    });
  }

  void _launchEmail(String emailId) async {
    var url = "mailto:$emailId?subject=Requesting for Help";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not send E-mail';
    }
  }

  _addClass(BuildContext context) async {
    progress = ProgressDialog(context, type: ProgressDialogType.Normal);
    progress.style(
      message: "Adding Class",
    );
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Class details"),
            content: SizedBox(
                height: 130.0,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          controller: _classcode,
                          decoration: InputDecoration(labelText: "Class Code"),
                          validator: (value) {
                            Firestore.instance
                                .collection("Classes")
                                .where("code", isEqualTo: _classcode.text)
                                .snapshots()
                                .listen((onData) {
                              if (onData.documents != null) {
                                setState(() {
                                  String temp =
                                      onData.documents[0].data['code'];
                                  demo = temp;
                                });
                              }
                            });
                            if (value == demo) {
                              return null;
                            } else {
                              return "No Such Class Found";
                            }
                          })
                    ],
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      String code = _classcode.text;
                      progress.show();
                      userM.addNewClass(code, context);
                      Future.delayed(Duration(seconds: 2)).then((onValue) {
                        progress.update(message: "Initializing Class");
                      });
                      Future.delayed(Duration(seconds: 3)).then((onValue) {
                        progress.hide().whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      });
                      _formKey.currentState.reset();
                    }
                  },
                  child: Text("Ok")),
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
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
        elevation: 30.0,
      ),
      body: classData(),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.only(top: 20.0),
          color: Colors.brown[200],
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage('images/logo.png'),
                radius: 70.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              Text(
                "Study Plus",
                style: TextStyle(
                    color: Colors.brown[900],
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40.0,
              ),
              FlatButton.icon(
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    Firestore.instance
                        .collection('user')
                        .where('Email', isEqualTo: user.email)
                        .getDocuments()
                        .then((uid) {
                      if (uid.documents[0].exists) {
                        if (uid.documents[0].data['Role'] == 'TEACHER') {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      TeacherPage()));
                        } else {
                          setState(() {
                            error =
                                'You are not Authorized \n        to access this \n                page';
                          });
                        }
                      }
                    });
                  });
                },
                icon: Icon(
                  Icons.school,
                  color: Colors.brown[900],
                ),
                label: Text(
                  'Teachers Only',
                  style: TextStyle(color: Colors.brown[900]),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
                icon: Icon(
                  Icons.account_circle,
                  color: Colors.brown[900],
                ),
                label: Text(
                  'Profile',
                  style: TextStyle(color: Colors.brown[900]),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalenderPage()),
                  );
                },
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.brown[900],
                ),
                label: Text(
                  'Calender',
                  style: TextStyle(color: Colors.brown[900]),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton.icon(
                onPressed: () {
                  _launchEmail('studyapp12345@gmail.com');
                },
                icon: Icon(
                  Icons.contact_mail,
                  color: Colors.brown[900],
                ),
                label: Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.brown[900]),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUs()),
                  );
                },
                icon: Icon(
                  Icons.speaker_group,
                  color: Colors.brown[900],
                ),
                label: Text(
                  'About Us',
                  style: TextStyle(color: Colors.brown[900]),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                  );
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.brown[900],
                ),
                label: Text(
                  'Logout',
                  style: TextStyle(color: Colors.brown[900]),
                ),
              ),
              SizedBox(height: 40.0),
              Center(
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown[400],
        onPressed: () {
          FirebaseAuth.instance.currentUser().then((user) {
            Firestore.instance
                .collection('user')
                .where('Email', isEqualTo: user.email)
                .getDocuments()
                .then((uid) {
              if (uid.documents[0].exists) {
                if (uid.documents[0].data['Role'] == 'STUDENT') {
                  _addClass(context);
                } else {
                  setState(() {
                    error1 =
                        'You are not Authorized \n        to access this \n               Module';
                    errorDialog(context);
                  });
                }
              }
            });
          });
        },
        icon: Icon(
          Icons.add,
          size: 30.0,
        ),
        label: Text("Join Class"),
      ),
    );
  }

  Widget classData() {
    if (info != null) {
      return StreamBuilder(
        stream: info,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        snapshot.data.documents[index].data['className'],
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      trailing: GestureDetector(
                        child: Icon(
                          Icons.chevron_right,
                          size: 20.0,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ClassFile(
                                  snapshot
                                      .data.documents[index].data['className'],
                                  snapshot
                                      .data.documents[index].data['code'])));
                        },
                      ),
                      contentPadding: EdgeInsets.all(20.0),
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
      return Center(child: Text("Loading..."));
    }
  }

  errorDialog(context) {
    return showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Unauthorized Activity"),
          content: SizedBox(
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.do_not_disturb,
                  color: Colors.red,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.0),
                ),
                Text(error1)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ));
  }
}
