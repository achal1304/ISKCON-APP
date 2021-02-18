import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

//import 'package:font_awesome_flutter/font';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'crud.dart';
import 'normalusers.dart';
import 'premium.dart';

const kGoogleApiKey = "AIzaSyDA2vSkZdEb9_8Gz-ivOP1vW8QOu01xEW0";

class Item {
  const Item(this.gender, this.icon);

  final String gender;
  final FaIcon icon;
}

class SignUpEditProfile extends StatefulWidget {
  FirebaseUser _user;
  GoogleSignIn _googleSignIn;

  SignUpEditProfile(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _SignUpEditProfileState createState() => _SignUpEditProfileState();
}

class _SignUpEditProfileState extends State<SignUpEditProfile> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String radioButtonItem = '';

  // Group Value for Radio Button.
  int id = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Item selectedGender;

  // var arr = [false, false, false, false];
  // List<Item> genders = <Item>[
  //   const Item(
  //     'Male',
  //     FaIcon(
  //       FontAwesomeIcons.mars,
  //       color: Colors.blue,
  //     ),
  //   ),
  //   const Item(
  //       'Female',
  //       FaIcon(
  //         FontAwesomeIcons.venus,
  //         color: Colors.pink,
  //       )),
  //   const Item(
  //       'Other',
  //       FaIcon(
  //         FontAwesomeIcons.transgender,
  //         color: Colors.purple,
  //       )),
  //   const Item(
  //       'Prefer not to specify',
  //       FaIcon(
  //         FontAwesomeIcons.genderless,
  //         color: Colors.grey,
  //       )),
  // ];

  FirebaseUser user;

  String dob = "";
  String uname;
  String uaddress;
  String gender = "";
  double progress = 0.25;
  String progressPercent = "25%";
  Timestamp birthday = Timestamp.now();
  Prediction p;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static SharedPreferences _sharedPreferences;

  Future<FirebaseUser> getUser() async {
    FirebaseUser usr = await FirebaseAuth.instance.currentUser();
    return usr;
  }

  // loadProgressValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     progress = (prefs.getDouble('progress')) ?? 0.25;
  //     // progress = data['progress'] ?? 0.25;
  //     progressPercent = (prefs.getString('percent')) ?? '25%';
  //   });
  // }

  // saveProgressValue() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.setDouble('progress', progress);
  //     if (progress == 0.25) {
  //       progressPercent = "25%";
  //     } else if (progress == 0.5) {
  //       progressPercent = "50%";
  //     } else if (progress == 0.75) {
  //       progressPercent = "75%";
  //     } else if (progress == 1.0) {
  //       progressPercent = "100%";
  //     }
  //     prefs.setString('percent', progressPercent);
  //   });
  // }
  double saveProgressValue(var arr) {
    setState(() {
      if (arr[0] == true) {
        progress = 0.25;
      }
      if (arr[1] == true) {
        progress += 0.25;
      }
      if (arr[2] == true) {
        progress += 0.25;
      }
      if (arr[3] == true) {
        progress += 0.25;
      }
    });
    return progress;
  }

  String savePercentValue(double progress) {
    setState(() {
      if (progress == 0.25) {
        progressPercent = "25%";
      } else if (progress == 0.5) {
        progressPercent = "50%";
      } else if (progress == 0.75) {
        progressPercent = "75%";
      } else if (progress == 1.0) {
        progressPercent = "100%";
      }
    });
    return progressPercent;
  }

  dynamic data;

  Future<dynamic> getUserProgress() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(widget._user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  checkAndUpdate() async {
    uname = name.text;
    uaddress = address.text;
    progress = data['progress'];
    var arr = data['ARR'];

    if (dob.isNotEmpty) {
      Crud().updateDOB(user, dob, birthday);
      if (arr[1] == false)
        // setState(() {
        //   if (progress < 1.0) progress += 0.25;
        //   saveProgressValue();
        //   if (progress == 0.25) {
        //     progressPercent = "25%";
        //   } else if (progress == 0.5) {
        //     progressPercent = "50%";
        //   } else if (progress == 0.75) {
        //     progressPercent = "75%";
        //   } else if (progress == 1.0) {
        //     progressPercent = "100%";
        //   }
        arr[1] = true;
      // });
    }
    if (uname.isNotEmpty) {
      Crud().updateName(user, uname);
    }
    if (uaddress.isNotEmpty) {
      Crud().updateAddress(user, uaddress);
      if (arr[2] == false)
        // setState(() {
        //   if (progress < 1.0) progress += 0.25;
        //   saveProgressValue();
        //   if (progress == 0.25) {
        //     progressPercent = "25%";
        //   } else if (progress == 0.5) {
        //     progressPercent = "50%";
        //   } else if (progress == 0.75) {
        //     progressPercent = "75%";
        //   } else if (progress == 1.0) {
        //     progressPercent = "100%";
        //   }
        arr[2] = true;
      // });
    }
    if (radioButtonItem.isNotEmpty) {
      Crud().updateGender(user, radioButtonItem);
      if (arr[3] == false)
        // setState(() {
        //   if (progress < 1.0) progress += 0.25;
        //   saveProgressValue();
        //   if (progress == 0.25) {
        //     progressPercent = "25%";
        //   } else if (progress == 0.5) {
        //     progressPercent = "50%";
        //   } else if (progress == 0.75) {
        //     progressPercent = "75%";
        //   } else if (progress == 1.0) {
        //     progressPercent = "100%";
        //   }
        arr[3] = true;
      // });
    }
    setState(() {
      progress = saveProgressValue(arr);
      progressPercent = savePercentValue(progress);
    });

    Crud().updateProgress(user, progress);
    Crud().updateProgressPercent(user, progressPercent);
    Crud().updateArr(user, arr);
  }

  List<bool> _list = [false, false, false, false];

  @override
  void initState() {
    getUser().then((FirebaseUser usr) {
      setState(() {
        user = usr;
      });
    });
    // getUserProgress();

    getUserProgress();
    // loadProgressValue();

    //progress = double.parse(data['progress']);
    if (progress == 0.25) {
      progressPercent = "25%";
    } else if (progress == 0.5) {
      progressPercent = "50%";
    } else if (progress == 0.75) {
      progressPercent = "75%";
    } else if (progress == 1.0) {
      progressPercent = "100%";
    }

    super.initState();
  }

  void onError(PlacesAutocompleteResponse response) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // progress = data['progress'];
    // progressPercent = data['progressPercent'];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Update Profile',
            style: TextStyle(color: Colors.black),
            textScaleFactor: 1.2,
          ),
          backgroundColor: Colors.white,
          elevation: 0.5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(widget._user.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error : ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    progress = snapshot.data['progress'];
                    progressPercent = snapshot.data['progressPercent'];
                    return Container(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.08,
                      ),
                      child: GFProgressBar(
                        percentage: progress < 1.0 ? progress : 1.0,
                        lineHeight: 20,
                        animation: true,

                        //padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                        alignment: MainAxisAlignment.spaceBetween,
                        child: Text(
                          progressPercent,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        backgroundColor: Colors.black26,
                        progressBarColor: Colors.blueAccent,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    );
                  }
                  return LinearProgressIndicator();
                }),

            // Container(
            //   padding: EdgeInsets.only(
            //     left: MediaQuery.of(context).size.width * 0.08,
            //   ),
            //   child: GFProgressBar(
            //     percentage: progress < 1.0 ? progress : 1.0,
            //     lineHeight: 20,
            //     animation: true,

            //     //padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
            //     alignment: MainAxisAlignment.spaceBetween,
            //     child: Text(
            //       progressPercent,
            //       textAlign: TextAlign.end,
            //       style: TextStyle(fontSize: 16, color: Colors.white),
            //     ),
            //     backgroundColor: Colors.black26,
            //     progressBarColor: Colors.blueAccent,
            //     width: MediaQuery.of(context).size.width * 0.8,
            //   ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 70,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: Icon(Icons.person),
                  hintText: data['Name'],
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                controller: address,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: Icon(Icons.my_location),
                  hintText: data['Address'],
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
                onTap: () async {
                  try {
                    p = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: kGoogleApiKey,
                        onError: onError,
                        mode: Mode.fullscreen,
                        // Mode.fullscreen
                        language: "en",
                        components: [new Component(Component.country, "in")]);
                    // showDetailPlace(p.placeId);
                  } catch (e) {
                    return;
                  }
                  setState(() {
                    address.text = p.description;
                  });
//                  _handlePressButton();
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            //   DropdownButton<Item>(
            //     hint: Text("Gender"),
            //     value: selectedGender,
            //     onChanged: (Item genderValue) {
            //       setState(() {
            //         selectedGender = genderValue;
            //       });
            //     },
            //     items: genders.map((Item gender) {
            //       return DropdownMenuItem<Item>(
            //         value: gender,
            //         child: Row(
            //           children: <Widget>[
            //             gender.icon,
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(
            //               gender.gender,
            //               style: TextStyle(color: Colors.black),
            //             ),
            //           ],
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // Container(
            //   width: MediaQuery.of(context).size.width * 0.8,
            //   height: MediaQuery.of(context).size.width * 0.12,
            //   child: GFButton(
            //     onPressed: () {},
            //     text: "Date of Birth",
            //     icon: FaIcon(FontAwesomeIcons.birthdayCake),
            //     color: Colors.grey,
            //     type: GFButtonType.outline,
            //     shape: GFButtonShape.pills,
            //     size: GFSize.LARGE,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: TextFormField(
                //controller: address,
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());

                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
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
                      dob = DateFormat('dd/MM/yyyy').format(date);
                      birthday = Timestamp.fromDate(date);
                    });
                    //print('date................' + sdate);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  prefixIcon: Icon(Icons.cake),
                  hintText: dob == "" ? 'DOB: dd/mm/yyyy' : dob,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            if (data['Gender'] == null)
              Text("Gender :")
            else
              Text("Gender : " + data['Gender']),
            Column(
              children: <Widget>[
                // Padding(
                //     padding: EdgeInsets.all(14.0),
                //     child: Text('Selected Radio Item = ' + '$radioButtonItem',
                //         style: TextStyle(fontSize: 21))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Radio(
                      value: 1,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Male';
                          id = 1;
                        });
                      },
                    ),
                    Text(
                      'Male',
                      style: new TextStyle(fontSize: 17.0),
                    ),
                    Radio(
                      value: 2,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Female';
                          id = 2;
                        });
                      },
                    ),
                    Text(
                      'Female',
                      style: new TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    Radio(
                      value: 3,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioButtonItem = 'Other';
                          id = 3;
                        });
                      },
                    ),
                    Text(
                      'Other',
                      style: new TextStyle(fontSize: 17.0),
                    ),
                  ],
                ),
              ],
            ),
            // Text("Gender"),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     Container(
            //       width: MediaQuery.of(context).size.width * 0.120,
            //       height: MediaQuery.of(context).size.height * 0.062,
            //       child: GFIconButton(
            //         onPressed: () {
            //           setState(() {
            //             _list[0] = !_list[0];
            //             if (_list[1] != false) _list[1] = false;
            //             if (_list[2] != false) _list[2] = false;
            //             if (_list[3] != false) _list[3] = false;
            //             if (_list[0] == true) gender = "Male";
            //           });
            //         },
            //         icon: FaIcon(FontAwesomeIcons.mars),
            //         type: _list[0]
            //             ? GFButtonType.outline
            //             : GFButtonType.transparent,
            //         iconSize: 35,
            //         size: GFSize.LARGE,
            //         tooltip: 'male',
            //       ),
            //     ),
            //     Container(
            //       width: MediaQuery.of(context).size.width * 0.125,
            //       height: MediaQuery.of(context).size.height * 0.062,
            //       child: GFIconButton(
            //         onPressed: () {
            //           setState(() {
            //             _list[1] = !_list[1];
            //             if (_list[0] != false) _list[0] = false;
            //             if (_list[2] != false) _list[2] = false;
            //             if (_list[3] != false) _list[3] = false;
            //             if (_list[1] == true) gender = "Female";
            //           });
            //         },
            //         color: Colors.pink,
            //         icon: FaIcon(FontAwesomeIcons.venus),
            //         type: _list[1]
            //             ? GFButtonType.outline
            //             : GFButtonType.transparent,
            //         iconSize: 34,
            //         size: GFSize.LARGE,
            //         tooltip: 'female',
            //       ),
            //     ),
            //     Container(
            //       width: MediaQuery.of(context).size.width * 0.125,
            //       height: MediaQuery.of(context).size.height * 0.062,
            //       child: GFIconButton(
            //         onPressed: () {
            //           setState(() {
            //             _list[2] = !_list[2];
            //             if (_list[0] != false) _list[0] = false;
            //             if (_list[1] != false) _list[1] = false;
            //             if (_list[3] != false) _list[3] = false;
            //             if (_list[2] == true) gender = "Other";
            //           });
            //         },
            //         color: Colors.purple,
            //         icon: FaIcon(FontAwesomeIcons.venusMars),
            //         type: _list[2]
            //             ? GFButtonType.outline
            //             : GFButtonType.transparent,
            //         iconSize: 33,
            //         size: GFSize.LARGE,
            //         tooltip: 'other',
            //       ),
            //     ),
            //   ],
            // ),
            // Container(
            //   child: GFButton(
            //     onPressed: () {
            //       setState(() {
            //         _list[3] = !_list[3];
            //         if (_list[0] != false) _list[0] = false;
            //         if (_list[1] != false) _list[1] = false;
            //         if (_list[2] != false) _list[2] = false;
            //         if (_list[3] == true) gender = "NaN";
            //       });
            //     },
            //     text: 'Prefer not to tell',
            //     highlightColor: Theme.of(context).scaffoldBackgroundColor,
            //     splashColor: Theme.of(context).scaffoldBackgroundColor,
            //     focusColor: Theme.of(context).scaffoldBackgroundColor,
            //     hoverColor: Theme.of(context).scaffoldBackgroundColor,
            //     type:
            //         _list[3] ? GFButtonType.outline : GFButtonType.transparent,
            //   ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: GFButton(
                onPressed: () async {
                  uname = name.text;
                  uaddress = address.text;
                  checkAndUpdate();

                  //getUserProgress();
                  // if (dob.isNotEmpty) {
                  //   Crud().updateDOB(user, dob);
                  //   progress += 0.25;
                  // }
                  // if (uname.isNotEmpty) {
                  //   Crud().updateName(user, uname);
                  // }
                  // if (uaddress.isNotEmpty) {
                  //   Crud().updateAddress(user, uaddress);
                  //   progress += 0.25;
                  // }
                  // if (gender.isNotEmpty) {
                  //   Crud().updateGender(user, gender);
                  //   progress += 0.25;
                  // }
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Thanks for updating profile!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
//                  Timer(Duration(seconds: 2), () {
                  // 5s over, navigate to a new page
//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => NormalUsers(
//                          widget._user,
//                          widget._googleSignIn,
//                        ),
//                      ),
//                    );
//                  });
                  //Navigator.pop(context);
                },
                text: "Update Profile",
                shape: GFButtonShape.pills,
                size: GFSize.LARGE,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PremiumCode(
                      widget._user,
                      widget._googleSignIn,
                    ),
                  ),
                );
              },
              child: new Text(
                "Go to dashboard",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                    color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
