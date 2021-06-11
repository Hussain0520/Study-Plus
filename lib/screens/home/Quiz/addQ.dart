import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studyplus/screens/home/addfilepage.dart';

import 'Database/database.dart';
class AddQuestion extends StatefulWidget {
  String code;
  AddQuestion(this.code);
  @override
  _AddQuestionState createState() => _AddQuestionState(code);
}

class _AddQuestionState extends State<AddQuestion> {
  final _formkey = GlobalKey<FormState>();
  String code;
  String question = "", option1 = "",option2 = "",option3 = "",option4 = "";
  bool _isLoading = false;
  _AddQuestionState(this.code);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Question"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Form(
        key: _formkey,
          child: _isLoading ? Center(child:SpinKitChasingDots(color: Colors.brown,))
              : ListView(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Question"
                            ),
                            validator: (val) => val.isEmpty ? "Enter the Question" : null,
                            onChanged: (val){question = val;},
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Option-1 (Correct Answer)"
                            ),
                            validator: (val) => val.isEmpty ? "Enter the Option" : null,
                            onChanged: (val){option1 = val;},
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Option-2"
                            ),
                            validator: (val) => val.isEmpty ? "Enter the Option" : null,
                            onChanged: (val){option2 = val;},
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Option-3"
                            ),
                            validator: (val) => val.isEmpty ? "Enter the Option" : null,
                            onChanged: (val){option3 = val;},
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "Option - 4"
                            ),
                            validator: (val) => val.isEmpty ? "Enter the Option" : null,
                            onChanged: (val){option4 = val;},
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 50.0),),
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: ()
                          {
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text("This Question will Not considered"),
                                  content: Text("Press Ok to Continue or press Cancel"),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: (){Navigator.pop(context);
                                      Navigator.pop(context);
                                      },
                                      child: Text("Ok"),
                                    ),
                                    FlatButton(
                                      onPressed: (){Navigator.pop(context);},
                                      child: Text("Cancel"),
                                    )
                                  ],
                                )
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 40.0,right: 40.0),
                            height: 40.0,
                            width: 100.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Submit",style: TextStyle(color: Colors.white),),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.circular(30.0)
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 20.0),),
                        GestureDetector(
                          onTap: (){uploadData();},
                          child: Container(
                            height: 40.0,
                            width: 100.0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Add Question",style: TextStyle(color: Colors.white)),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.brown,
                                borderRadius: BorderRadius.circular(30.0)
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
      )
    );
  }
  uploadData()
  {
    if(_formkey.currentState.validate())
      {
        setState(() {
          _isLoading = true;
        });
        Map<String,String> uploadQ = {
          "Question": question,
          "option1" : option1,
          "option2" : option2,
          "option3" : option3,
          "option4" : option4
        };
        Database.uploadQuestion(uploadQ,code).then((data){
          question = "";
          option4 = "";
          option2 = "";
          option1 = "";
          option3 = "";
          setState(() {
            _isLoading = false;
          });
        });
      }
  }
}
