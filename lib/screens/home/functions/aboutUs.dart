import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyplus/screens/home/home.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('About Us'),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Card(
              color: Colors.brown[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 69.0,
                    backgroundImage: AssetImage('images/Hussain.JPG'),
                  ),
                  Text(
                    'Hussain Saherwala',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.brown[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'DEVANG PATEL INSTITUTE OF ADVANCE \n       TECHNOLOGY AND RESEARCH',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.brown[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    color: Colors.brown[200],
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.brown[700],
                      ),
                      title: Text(
                        '18dcs101@charusat.edu.in',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.brown[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.brown[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 69.0,
                    backgroundImage: AssetImage('images/naitik.jpeg'),
                  ),
                  Text(
                    'Naitik Pandya',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Colors.brown[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'DEVANG PATEL INSTITUTE OF ADVANCE \n       TECHNOLOGY AND RESEARCH',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.brown[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                    color: Colors.brown[200],
                    margin: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25.0,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.email,
                        color: Colors.brown[700],
                      ),
                      title: Text(
                        'd19dcs156@charusat.edu.in',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.brown[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
