import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/crud.dart';
import 'package:login/homeL.dart';
import 'package:login/homeS.dart';
import 'package:login/normalusers.dart';
import 'package:login/signupeditprofile.dart';
import 'package:random_color/random_color.dart';

import 'adminpage.dart';

//var flag = 0;

class PremiumCode extends StatefulWidget {
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;

  PremiumCode(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _PremiumCodeState createState() => _PremiumCodeState();
}

class _PremiumCodeState extends State<PremiumCode> {
  StreamSubscription<DocumentSnapshot> subscription;

  AsyncSnapshot<DocumentSnapshot> snapshot1;
  dynamic data;
  bool prem = false;
  bool pcheck = false;
  String couppp = "";
  TextEditingController coup = TextEditingController();

  void addOnStart(dynamic data, bool prem) {
    //if (data == true)
    // Crud().storeData1(widget._user, data, prem);
    Crud().storeDataOfCouponsSignup(widget._user, data, prem);
    // else
    //   Crud().storeData(widget._user);
  }

  Future<dynamic> getUserProgress() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(widget._user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot1) async {
      setState(() {
        data = snapshot1.data['admin'];
        prem = snapshot1.data['premium'];
      });
    });
  }

  @override
  void initState() {
    getUserProgress();
//    addOnStart(data, prem);

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
      child: showthis(),
    );
  }

  Widget showthis() {
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
    return new Scaffold(
      body: Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: coup,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                prefixIcon: Icon(Icons.person),
                fillColor: Colors.white,
                hintText: "Please Enter Coupon code",
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 32.0),
                    borderRadius: BorderRadius.circular(25.0)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 32.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            GFButton(
              onPressed: () async {
                setState(() {
                  couppp = coup.text;
                });

                checkprem(couppp);
                addOnStart(data, pcheck);
              },
              text: "Verify",
              shape: GFButtonShape.pills,
              size: GFSize.LARGE,
            ),
            singleclick(couppp),
            couponcheck(),
          ],
        ),
      ),
    );
  }

  Widget singleclick(String pc) {
    if (pcheck == true) {
      print("in singleclick");
      return GFButton(
        onPressed: () async {
          Future.delayed(Duration.zero, () async {
            checkprem(couppp);
            addOnStart(data, pcheck);
            if (pcheck == true) {
              Crud().deleteCouponData(pc);
              print("pcheck=true in singleclick");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageL(
                    widget._user,
                    widget._googleSignIn,
                  ),
                ),
              );
            }
          });
        },
        text: "Visit App",
        shape: GFButtonShape.pills,
        size: GFSize.LARGE,
      );
    } else
      return Container(
        width: 0.0,
        height: 0.0,
      );
  }

  Widget couponcheck() {
    if (pcheck == true) {
      return Text(
        "Coupon Verified",
        style: TextStyle(color: Colors.white),
      );
    } else {
      print("In couponcheck");
      return Text(
        "Please enter a valid coupon code",
        style: TextStyle(color: Colors.red),
      );
    }
  }

  Future checkprem(String premcoupon) async {
    final DocumentReference documentReference =
        Firestore.instance.collection('PremiumCoupons').document(premcoupon);
    subscription = documentReference.snapshots().listen((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          pcheck = true;
        });
        print("in checkprem pcheck=true");
      }
      if (!datasnapshot.exists) {
        setState(() {
          pcheck = false;
        });
        print("in checkprem pcheck=false");
      }
    });
  }
}
