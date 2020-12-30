import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:login/ViewCoupons.dart';
import 'crud.dart';

class FoodCoupon extends StatefulWidget {
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;
  final int initNumber;

  FoodCoupon(
    FirebaseUser user,
    GoogleSignIn signIn, {
    this.initNumber,
  }) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _FoodCouponState createState() => _FoodCouponState();
}

class _FoodCouponState extends State<FoodCoupon> {
  int _currentCount = 0;
  int _currentCountDinn = 0;
  int _currentCountBrake = 0;
  int couponsavail;
  String dob = DateFormat('dd-MM-yyyy').format(DateTime.now());
  int prevbreak = 0;
  int prevlunch = 0;
  int prevdinn = 0;
  int ca;
  DateTime daynow = DateTime.now().add((Duration(days: 3)));

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  dynamic data;

  Future<dynamic> getUserProgress() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(widget._user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      // data = snapshot.data;
      //couponsavail = data['FoodCoupons'];
      setState(() {
        data = snapshot.data;
        couponsavail = data['FoodCoupons'];
        ca = couponsavail;
      });
    });
  }

  void initState() {
    getUserProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //couponsavail = data['FoodCoupons'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Book Coupons',
          style: TextStyle(color: Colors.black),
          textScaleFactor: 1.2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: FaIcon(Icons.arrow_back_ios),
          color: Colors.black,
          iconSize: 35,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              "Coupons Available : " + couponsavail.toString(),
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 24,
                  color: Colors.black54),
            ),
            Divider(
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                //controller: address,
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  showDatePicker(
                    context: context,
                    initialDate: daynow,
                    firstDate: daynow,
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: Colors.blue, //Head background
                          accentColor: Colors.blue, //selection color
                          colorScheme: ColorScheme.light(primary: Colors.blue),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                          //dialogBackgroundColor: Colors.white,//Background color
                        ),
                        child: child,
                      );
                    },
                  ).then((date) {
                    setState(() {
                      dob = DateFormat('dd-MM-yyyy').format(date);
                    });
                    //print('date................' + sdate);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//                  prefixIcon: Icon(Icons.cake),
                  hintText: dob,
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 32.0),
                      borderRadius: BorderRadius.circular(25.0)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 32.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget._user.uid)
                    .collection("Food Coupons")
                    .document(dob)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error : ${snapshot.error}');
                  } else if (snapshot.data.exists) {
                    prevbreak = snapshot.data['Breakfast'];
                    prevlunch = snapshot.data['Lunch'];
                    prevdinn = snapshot.data['Dinner'];
                    if (prevbreak == null)
                      setState(() {
                        prevbreak = 0;
                      });
                    if (prevlunch == null)
                      setState(() {
                        prevlunch = 0;
                      });
                    if (prevdinn == null)
                      setState(() {
                        prevdinn = 0;
                      });

                    return Container(
                      height: 0.0,
                      width: 0.0,
                    );
                  }
                  return Container(
                    height: 0.0,
                    width: 0.0,
                  );
                }),
            Container(
              decoration: BoxDecoration(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                    Text(
//                      "Avialable coupon  :" + couponsavail.toString(),
//                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("lunch Copoun")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _createIncrementDicrementButton(
                            Icons.remove, () => _dicrement()),
                        Text(_currentCount.toString()),
                        _createIncrementDicrementButton(
                            Icons.add, () => _increment()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Diner Coupon")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _createIncrementDicrementButton(
                            Icons.remove, () => _dicrementDin()),
                        Text(_currentCountDinn.toString()),
                        _createIncrementDicrementButton(
                            Icons.add, () => _incrementDin()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("Brakefast Copoun")],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _createIncrementDicrementButton(
                            Icons.remove, () => _dicrementBra()),
                        Text(_currentCountBrake.toString()),
                        _createIncrementDicrementButton(
                            Icons.add, () => _incrementBra()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            GFButton(
              onPressed: () async {
                if (_currentCount + _currentCountBrake + _currentCountDinn !=
                        0 &&
                    dob != "Select date") {
                  await Crud().addFoodCoupons(
                      widget._user,
                      _currentCountBrake + prevbreak,
                      _currentCount + prevlunch,
                      _currentCountDinn + prevdinn,
                      dob);

                  // DocumentReference documentref = Firestore.instance
                  //     .collection("users")
                  //     .document(widget._user.uid);

                  // await documentref
                  //     .get()
                  //     .then<dynamic>((DocumentSnapshot snapshot) async {
                  //   setState(() {
                  //     ca = data['FoodCoupons'];
                  //   });
                  // });

                  // setState(() {
                  //   couponsavail = ca -
                  //       _currentCountBrake -
                  //       _currentCount -
                  //       _currentCountDinn;
                  // });
                  await Crud().updateCouponsAvail(widget._user, couponsavail);

                  DocumentReference df = Firestore.instance
                      .collection('FoodCouponsAdmin')
                      .document(dob);

                  df.get().then((docSnapshot) => {
                        if (!docSnapshot.exists)
                          {
                            df.setData({
                              "$dob": {
                                "${widget._user.displayName}":
                                    _currentCountBrake +
                                        prevbreak +
                                        _currentCount +
                                        prevlunch +
                                        _currentCountDinn +
                                        prevdinn,
                              }
                            })
                          }
                        else
                          {
                            df.updateData({
                              "$dob.${widget._user.displayName}":
                                  _currentCountBrake +
                                      prevbreak +
                                      _currentCount +
                                      prevlunch +
                                      _currentCountDinn +
                                      prevdinn,
                            })
                          }
                      });

                  // await df.setData({
                  //   "$dob.${widget._user.email}": _currentCountBrake +
                  //       prevbreak +
                  //       _currentCount +
                  //       prevlunch +
                  //       _currentCountDinn +
                  //       prevdinn,
                  // });
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Coupons Booked'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                if (dob == "Select date") {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Please select date'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                if (_currentCount + _currentCountBrake + _currentCountDinn ==
                    0) {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Please select coupons'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                setState(() {
                  _currentCount = 0;
                  _currentCountBrake = 0;
                  _currentCountDinn = 0;
                });
              },
              text: "Book Coupons",
              shape: GFButtonShape.pills,
              size: GFSize.LARGE,
            ),
            GFButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewCoupons(
                      //isAdmin: false,
                      widget._user,
                      widget._googleSignIn,
                    ),
                  ),
                );
              },
              text: "View Coupons",
              shape: GFButtonShape.pills,
              size: GFSize.LARGE,
            ),
          ],
        ),
      ),
    );
  }

  void _increment() {
    setState(() {
      if (couponsavail > 0) {
        _currentCount++;
        couponsavail--;
      }
    });
  }

  void _dicrement() {
    setState(() {
      if (_currentCount > 0) {
        _currentCount--;
        couponsavail++;
      }
    });
  }

  void _incrementDin() {
    if (couponsavail > 0) {
      setState(() {
        _currentCountDinn++;
        couponsavail--;
      });
    }
  }

  void _dicrementDin() {
    setState(() {
      if (_currentCountDinn > 0) {
        _currentCountDinn--;
        couponsavail++;
      }
    });
  }

  void _incrementBra() {
    if (couponsavail > 0) {
      setState(() {
        _currentCountBrake++;
        couponsavail--;
      });
    }
  }

  void _dicrementBra() {
    setState(() {
      if (_currentCountBrake > 0) {
        _currentCountBrake--;
        couponsavail++;
      }
    });
  }

  Widget _createIncrementDicrementButton(IconData icon, Function onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: BoxConstraints(minWidth: 32.0, minHeight: 32.0),
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: Colors.deepOrangeAccent,
      child: Icon(
        icon,
        color: Colors.black,
        size: 12.0,
      ),
      shape: CircleBorder(),
    );
  }
}
