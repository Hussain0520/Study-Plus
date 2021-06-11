import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:studyplus/screens/home/home.dart';
import 'usermanagement.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _edit = false;
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _clg;
  TextEditingController _num;
  TextEditingController _con;
  TextEditingController _role;
  var userM = UserManagement();
  Future<Null> info;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      String uid = user.uid;
      userM.userData(uid).get().then((snapshot) {
        if (snapshot.exists) {
          setState(() {
            _name = TextEditingController(text: snapshot.data['Name']);
            _email = TextEditingController(text: snapshot.data['Email']);
            _num = TextEditingController(text: snapshot.data['contact']);
            _clg = TextEditingController(text: snapshot.data['college']);
            _con = TextEditingController(text: snapshot.data['Country']);
            _role = TextEditingController(text: snapshot.data['Role']);
          });
        }
      });
    });
  }

  final key = GlobalKey<ScaffoldState>();

  Widget custom() {
    final snackBar = SnackBar(content: Text("Editing Is Enabled Now"));
    final _snackBar = SnackBar(content: Text("Data Is Updated"));
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.brown[700],
                            ),
                            onPressed: () {
                              key.currentState.showSnackBar(snackBar);
                              setState(() {
                                _edit = true;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.check,
                              color: Colors.brown[700],
                            ),
                            onPressed: () {
                              key.currentState.showSnackBar(_snackBar);
                              var user = new UserManagement();
                              user.userInfo(_name.text, _email.text, _clg.text,
                                  _con.text, _num.text, context);
                              setState(() {
                                _edit = false;
                              });
                            }),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: AssetImage('images/logo.png'),
                      radius: 20.0,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Study Plus",
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[900]),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 15.0, bottom: 15.0),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage('images/profile.png'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
              ),
              SizedBox(
                width: 150.0,
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: "Name"),
                  enabled: _edit,
                ),
              )
            ],
          )
        ],
      ),
      height: 235.0,
      decoration: BoxDecoration(
          color: Colors.brown[200],
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35.0),
              bottomRight: Radius.circular(35.0))),
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(right: 25.0, left: 25.0),
      child: Wrap(
        direction: Axis.horizontal,
        runSpacing: 20.0,
        children: <Widget>[
          TextFormField(
            controller: _email,
            decoration: InputDecoration(
              labelText: "E-mail",
            ),
            enabled: _edit,
          ),
          TextFormField(
            controller: _clg,
            decoration: InputDecoration(
              labelText: "School/College",
            ),
            enabled: _edit,
          ),
          TextFormField(
            controller: _con,
            decoration: InputDecoration(
              labelText: "Country",
            ),
            enabled: _edit,
          ),
          TextFormField(
            controller: _num,
            decoration: InputDecoration(
              labelText: "Phone Number",
            ),
            enabled: _edit,
          ),
          TextFormField(
            controller: _role,
            decoration: InputDecoration(
              labelText: "Role",
            ),
            enabled: false,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("PROFILE"),
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
      key: key,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[custom(), form()],
      ),
    );
  }
}
