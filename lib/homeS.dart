// import 'dart:async';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'crud.dart';
import 'normalusers.dart';
import 'signupeditprofile.dart';
import 'package:random_color/random_color.dart';

import 'adminpage.dart';

class HomePageS extends StatefulWidget {
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;
  HomePageS(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _HomePageSState createState() => _HomePageSState();
}

class _HomePageSState extends State<HomePageS> {
  // @override
  // void initState() {
  //   addOnStart(snapshot);
  //   super.initState();
  // }
  AsyncSnapshot<DocumentSnapshot> snapshot1;
  dynamic data;
  String a;
  bool prem = false;

  Future<dynamic> getUserProgress() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(widget._user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot1) async {
      setState(() {
        data = snapshot1.data['admin'];
        a = snapshot1.data['admin'];
        prem = snapshot1.data['premium'];
        print("new admin value is " + a);
      });
    });
  }

  @override
  void initState() {
    addOnStart(data, prem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor1 = RandomColor();
    Color _color1 = _randomColor1.randomColor(
        colorSaturation: ColorSaturation.highSaturation,
        colorHue: ColorHue.multiple(colorHues: <ColorHue>[ColorHue.blue]));

    MyColor _myColor1 = getColorNameFromColor(_color1);
    print(_myColor1.getName);

    RandomColor _randomColor2 = RandomColor();
    Color _color2 = _randomColor2.randomColor(
        colorSaturation: ColorSaturation.highSaturation,
        colorHue: ColorHue.multiple(colorHues: <ColorHue>[ColorHue.red]));
    MyColor _myColor2 = getColorNameFromColor(_color2);
    print(_myColor2.getName);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: /*[Colors.orange.shade300, Colors.orange.shade800]*/ [
            _color1,
            _color2
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(widget._user.photoUrl),
            radius: 70,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Welcome ${widget._user.displayName}!',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 15,
          ),
          StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(widget._user.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                //data = snapshot.data['admin'];
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return checkRole(snapshot.data);
                }
                return LinearProgressIndicator();
              }),
        ],
      ),
    );
  }

  void addOnStart(dynamic data, bool prem) {
    //if (data == true)
    Crud().storeData1(widget._user, data, prem);
    // else
    //   Crud().storeData(widget._user);
  }

  Widget checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: Text(
          'User not Found! Please Register first',
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
          ),
        ),
      );
    }
    if (snapshot.data['admin'] == true) {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  Widget adminPage(DocumentSnapshot snapshot) {
    Timer(Duration(seconds: 2), () {
      // 5s over, navigate to a new page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPage(
            widget._user,
            widget._googleSignIn,
          ),
        ),
      );
    });
    return Container(
        child: Center(
            child: Text(
      "Welcome to ISKCON Pune",
      style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.normal,
          fontFeatures: null),
    )));
//    return Center(
//      child: OutlineButton(
//        padding: EdgeInsets.symmetric(vertical: 15),
//        borderSide: BorderSide(color: Colors.white),
//        shape: StadiumBorder(),
//        textColor: Colors.white,
//        onPressed: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => AdminPage(
//                widget._user,
//                widget._googleSignIn,
//              ),
//            ),
//          );
//        },
//        child: Text('Go to Admin Dashboard'),
//      ),
//    );
  }

  Widget userPage(DocumentSnapshot snapshot) {
    Timer(Duration(seconds: 2), () {
      // 5s over, navigate to a new page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpEditProfile(
            widget._user,
            widget._googleSignIn,
          ),
        ),
      );
    });
    return Container(
        child: Center(
            child: Text(
      "Welcome to ISKCON Pune",
      style: TextStyle(
          decoration: TextDecoration.none,
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.normal,
          fontFeatures: null),
    )));
  }
}
