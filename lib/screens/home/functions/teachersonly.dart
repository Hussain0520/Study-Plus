import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studyplus/screens/home/addfilepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:studyplus/screens/home/home.dart';
import 'usermanagement.dart';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  TextEditingController _classname = TextEditingController();
  TextEditingController _classcode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var userM = UserManagement();
  Stream info;
  String demo = "code";
  bool test = false;
  ProgressDialog progress;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      userM.loadClassList(uid).then((result) {
        setState(() {
          info = result;
        });
      });
    });
  }

  _addClass(BuildContext context) async {
    progress = ProgressDialog(context, type: ProgressDialogType.Normal);
    progress.style(
      message: "Creating Class",
    );
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Class details"),
            content: SizedBox(
                height: 180.0,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _classname,
                        decoration: InputDecoration(labelText: "Class Name"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Provide a Proper Class Name";
                          }
                          return null;
                        },
                      ),
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
                                demo = onData.documents[0].data['code'];
                                test = true;
                              });
                            }
                          });
                          print(test);
                          if (value == demo) {
                            return "Class Code Already Exists";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      progress.show();

                      userM.storeNewClass(
                          _classname.text, _classcode.text, context);

                      Future.delayed(Duration(seconds: 2)).then((onValue) {
                        progress.update(message: "Initializing Class");
                      });
                      Future.delayed(Duration(seconds: 3)).then((onValue) {
                        progress.hide().whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      });
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
          backgroundColor: Colors.brown[400],
          title: Text("Teachers Page"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
        ),
        body: classData(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _addClass(context);
          },
          icon: Icon(Icons.class_),
          label: Text("Add Class"),
          backgroundColor: Colors.brown[500],
          isExtended: true,
        ));
  }

  Widget classData() {
    if (info != null) {
      return StreamBuilder(
        stream: info,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: SpinKitChasingDots(color: Colors.brown));
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(
                    snapshot.data.documents[index].data['class'],
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    snapshot.data.documents[index].data['code'],
                    style:
                        TextStyle(fontSize: 13.0, fontStyle: FontStyle.italic),
                  ),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete, color: Colors.white),
                    onTap: () {
                      userM.deleteClass(
                          snapshot.data.documents[index].documentID);
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AddFile(
                            snapshot.data.documents[index].data['class'],
                            snapshot.data.documents[index].documentID,snapshot.data.documents[index].data['code'])));
                  });
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          );
        },
      );
    } else {
      return Center(child: SpinKitChasingDots(color: Colors.brown));
    }
  }
}
