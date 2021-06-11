import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:studyplus/screens/home/Quiz/Database/database.dart';
import 'package:studyplus/screens/home/Quiz/addQ.dart';

class CreateQuiz extends StatefulWidget {
  String code;
  CreateQuiz(this.code);
  @override
  _CreateQuizState createState() => _CreateQuizState(code);
}

class _CreateQuizState extends State<CreateQuiz> {
  String code;
  _CreateQuizState(this.code);
 final _form = GlobalKey<FormState>();
 String qTitle , qDesc;
 bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Quiz"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body:  _isLoading ?Center(child:SpinKitChasingDots(color: Colors.brown,))
          : Center(
        child:Form(
            key: _form,
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage("images/logo.png"),
                    radius: 50.0,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 30.0),),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Quiz Title"
                    ),
                    validator: (val) => val.isEmpty ? "Enter the Quiz Title" : null,
                    onChanged: (val){qTitle = val;},
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Quiz Description"
                    ),
                    validator: (val) => val.isEmpty ? "Enter the Quiz Description" : null,
                    onChanged: (val){qDesc = val;},
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 50.0),),
                  GestureDetector(
                    onTap: (){_createQuiz();},
                    child: Container(
                      height: 40.0,
                      width: 100.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Create Quiz",style: TextStyle(color: Colors.white),),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                    ),
                  )
                ],
              ),
            )
        ),
      )
      );
  }
  _createQuiz()
  {
    if(_form.currentState.validate())
      {
        setState(() {
          _isLoading = true;
        });
        Map<String,String> quizData = {
          "QuizTitle": qTitle,
          "QuizDesc" : qDesc,
        };
        Database.createQuiz(quizData,code).then((data){
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddQuestion(code)
          ));
        });
      }

  }
}
