import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'adminpage.dart';
import 'picker.dart';
import 'signup.dart';
import 'package:random_color/random_color.dart';

import 'normalusers.dart';

class HomePageL extends StatefulWidget {
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;
  HomePageL(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _HomePageLState createState() => _HomePageLState();
}

class _HomePageLState extends State<HomePageL> {
  DateTime olddate = DateTime.now();
  dynamic data;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  @override
  void initState() {
    super.initState();
    initializing();
  }

  AsyncSnapshot<DocumentSnapshot> snapshot;

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
      //color: Colors.white,
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
                if (snapshot.hasError) {
                  return Text('Error : ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return checkRole(snapshot.data);
                }
                return LinearProgressIndicator();
              }),
        ],
      ),
    );
  }

  Widget checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Looks like you haven\'t registered yet!',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Please Register First!',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ButtonTheme(
              minWidth: 300,
              child: OutlineButton(
                shape: StadiumBorder(),
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Signup(),
                        fullscreenDialog: true,
                      ));
                },
                child: Text('Go to Registration Page'),

                //child: Text('Google Sign-up'),
              ),
            ),
          ],
        ),
      );
    }
    print("before test");
    if (snapshot.data['admin'] == true) {
      return adminPage(snapshot);
    } else {
      print("going to the user page");
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
    // return Center(
    //   child: Image(image: AssetImage('assets/iskconwhiteresize.png')),
    // );
    // return Center(
    //   child: ButtonTheme(
    //     minWidth: 300,
    //     child: OutlineButton(
    //       padding: EdgeInsets.symmetric(vertical: 15),
    //       borderSide: BorderSide(color: Colors.white),
    //       shape: StadiumBorder(),
    //       textColor: Colors.white,
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => AdminPage(
    //               widget._user,
    //               widget._googleSignIn,
    //             ),
    //           ),
    //         );
    //       },
    //       child: Text('Go to Admin\'s Dashboard'),
    //     ),
    //   ),
    // child: Text(
    //   "Welcome to Iskcon",
    //   textScaleFactor: 1.5,
    // );

    // child:
    // ButtonTheme(
    //   minWidth: 300,
    //   child: OutlineButton(
    //     padding: EdgeInsets.symmetric(vertical: 15),
    //     borderSide: BorderSide(color: Colors.white),
    //     shape: StadiumBorder(),
    //     textColor: Colors.white,
    //     onPressed: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => AdminPage(
    //             widget._user,
    //             widget._googleSignIn,
    //           ),
    //         ),
    //       );
    //     },
    //     child: Text('Go to Admin\'s Dashboard'),
    //   ),
    // );
  }

  Widget userPage(DocumentSnapshot snapshot) {
    var newHr = 10;
    var newMin = 0;
    var newSec = 0;
    var y;
    String nameuser = snapshot.data['Name'];
    if (snapshot.data['Birthday'] == null) {
      olddate = DateTime.now();
    } else {
      Timestamp t = snapshot.data['Birthday'];
      var date = t.toDate();
      olddate = date;
    }

    DateTime newdate = DateTime.now();
    if (olddate.day < newdate.day) {
      if (olddate.month < newdate.month) {
        y = newdate.year + 1;
      } else if (olddate.month == newdate.month) {
        y = newdate.year + 1;
      } else
        y = newdate.year;
    } else if (olddate.day == newdate.day) {
      if (olddate.month < newdate.month) {
        y = newdate.year + 1;
      } else if (olddate.month == newdate.month) {
        y = newdate.year;
      } else
        y = newdate.year;
    } else if (olddate.day > newdate.day) {
      if (olddate.month < newdate.month) {
        y = newdate.year + 1;
      } else if (olddate.month == newdate.month) {
        y = newdate.year;
      } else
        y = newdate.year;
    } else
      y = newdate.year;

    print(y);
    print("in user page");

    DateTime finaldate =
        new DateTime(y, olddate.month, olddate.day, newHr, newMin, newSec);
    Timer(Duration(seconds: 2), () {
      print(DateFormat('dd/MM/yyyy/H:m:s').format(finaldate));
      // if (snapshot.data['DOB'] != " ") {
      //   _showNotification(finaldate, nameuser);
      // }
      // if (DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
      //     snapshot.data['DOB']) {

      // }
      // 5s over, navigate to a new page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NormalUsers(
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
    // return Center
    //   child: ButtonTheme(
    //     minWidth: 300,
    //     child: OutlineButton(
    //       padding: EdgeInsets.symmetric(vertical: 15),
    //       borderSide: BorderSide(color: Colors.white),
    //       shape: StadiumBorder(),
    //       textColor: Colors.white,
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => NormalUsers(
    //               widget._user,
    //               widget._googleSignIn,
    //             ),
    //           ),
    //         );
    //       },
    //       child: Text('Go to Dashboard'),
    //     ),
    //   ),
    // child: Text(
    //   "Welcome to Iskcon",
    //   textScaleFactor: 1.5,
    // ),
    // );
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  void initializing() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailyDarshan(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> _showNotification(DateTime finaldate, String nameuser) async {
    var scheduledNotificationDateTime = finaldate;

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'ISKCON NVCC pune', 'ISKCON NVCC pune', 'channel description',
            // importance: Importance.Max,
            // priority: Priority.High,
            // ticker: 'ticker',
            styleInformation: BigTextStyleInformation('''Dear $nameuser,
  We wish you a very Happy Birthday.We pray to Sri Sri Radha Vrindavanchandraji that they bestow their blessings upon you and your family profusely. Hare Krishna!
Yours in service,
ISKCON NVCC
PUNE'''));
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Happy Birthday ' + nameuser,
      'Dear ' + nameuser + ',',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }
}

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:intl/intl.dart';
// import 'package:login/adminpage.dart';
// import 'package:login/picker.dart';
// import 'package:login/signup.dart';
// import 'package:random_color/random_color.dart';

// import 'normalusers.dart';

// class HomePageL extends StatefulWidget {
//   GoogleSignIn _googleSignIn;
//   FirebaseUser _user;
//   HomePageL(FirebaseUser user, GoogleSignIn signIn) {
//     _user = user;
//     _googleSignIn = signIn;
//   }

//   @override
//   _HomePageLState createState() => _HomePageLState();
// }

// class _HomePageLState extends State<HomePageL> {
//   DateTime olddate = DateTime.now();
//   dynamic data;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   AndroidInitializationSettings androidInitializationSettings;
//   IOSInitializationSettings iosInitializationSettings;
//   InitializationSettings initializationSettings;
//   @override
//   void initState() {
//     super.initState();
//     initializing();
//   }

//   AsyncSnapshot<DocumentSnapshot> snapshot;

//   @override
//   Widget build(BuildContext context) {
//     RandomColor _randomColor1 = RandomColor();
//     Color _color1 = _randomColor1.randomColor(
//         colorSaturation: ColorSaturation.highSaturation,
//         colorHue: ColorHue.multiple(colorHues: <ColorHue>[ColorHue.blue]));

//     MyColor _myColor1 = getColorNameFromColor(_color1);
//     print(_myColor1.getName);

//     RandomColor _randomColor2 = RandomColor();
//     Color _color2 = _randomColor2.randomColor(
//         colorSaturation: ColorSaturation.highSaturation,
//         colorHue: ColorHue.multiple(colorHues: <ColorHue>[ColorHue.red]));
//     MyColor _myColor2 = getColorNameFromColor(_color2);
//     print(_myColor2.getName);
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: /*[Colors.orange.shade300, Colors.orange.shade800]*/ [
//             _color1,
//             _color2
//           ],
//         ),
//       ),
//       //color: Colors.white,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           CircleAvatar(
//             backgroundImage: NetworkImage(widget._user.photoUrl),
//             radius: 70,
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           Text(
//             'Welcome ${widget._user.displayName}!',
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//                 decoration: TextDecoration.none),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           StreamBuilder<DocumentSnapshot>(
//               stream: Firestore.instance
//                   .collection('users')
//                   .document(widget._user.uid)
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text('Error : ${snapshot.error}');
//                 } else if (snapshot.hasData) {
//                   return checkRole(snapshot.data);
//                 }
//                 return LinearProgressIndicator();
//               }),
//         ],
//       ),
//     );
//   }

//   Widget checkRole(DocumentSnapshot snapshot) {
//     if (snapshot.data == null) {
//       return Center(
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   'Looks like you haven\'t registered yet!',
//                   style: TextStyle(
//                     decoration: TextDecoration.none,
//                     fontSize: 15,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               'Please Register first!',
//               style: TextStyle(
//                 decoration: TextDecoration.none,
//                 fontSize: 15,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             ButtonTheme(
//               minWidth: 300,
//               child: OutlineButton(
//                 shape: StadiumBorder(),
//                 textColor: Colors.white,
//                 borderSide: BorderSide(color: Colors.white),
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => Signup(),
//                         fullscreenDialog: true,
//                       ));
//                 },
//                 child: Text('Go to Registration Page'),

//                 //child: Text('Google Sign-up'),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     if (snapshot.data['admin'] == true) {
//       return adminPage(snapshot);
//     } else if (snapshot.data["premium"] == true) {
//       return userPage(snapshot);
//     }
//   }

//   Widget adminPage(DocumentSnapshot snapshot) {
//     Timer(Duration(seconds: 2), () {
//       // 5s over, navigate to a new page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AdminPage(
//             widget._user,
//             widget._googleSignIn,
//           ),
//         ),
//       );
//     });
//     return Container(
//         child: Center(
//             child: Text(
//       "Welcome to ISKCON PUNE",
//       style: TextStyle(
//           decoration: TextDecoration.none,
//           color: Colors.white,
//           fontSize: 22,
//           fontWeight: FontWeight.normal,
//           fontFeatures: null),
//     )));
//     // return Center(
//     //   child: Image(image: AssetImage('assets/iskconwhiteresize.png')),
//     // );
//     // return Center(
//     //   child: ButtonTheme(
//     //     minWidth: 300,
//     //     child: OutlineButton(
//     //       padding: EdgeInsets.symmetric(vertical: 15),
//     //       borderSide: BorderSide(color: Colors.white),
//     //       shape: StadiumBorder(),
//     //       textColor: Colors.white,
//     //       onPressed: () {
//     //         Navigator.push(
//     //           context,
//     //           MaterialPageRoute(
//     //             builder: (context) => AdminPage(
//     //               widget._user,
//     //               widget._googleSignIn,
//     //             ),
//     //           ),
//     //         );
//     //       },
//     //       child: Text('Go to Admin\'s Dashboard'),
//     //     ),
//     //   ),
//     // child: Text(
//     //   "Welcome to Iskcon",
//     //   textScaleFactor: 1.5,
//     // );

//     // child:
//     // ButtonTheme(
//     //   minWidth: 300,
//     //   child: OutlineButton(
//     //     padding: EdgeInsets.symmetric(vertical: 15),
//     //     borderSide: BorderSide(color: Colors.white),
//     //     shape: StadiumBorder(),
//     //     textColor: Colors.white,
//     //     onPressed: () {
//     //       Navigator.push(
//     //         context,
//     //         MaterialPageRoute(
//     //           builder: (context) => AdminPage(
//     //             widget._user,
//     //             widget._googleSignIn,
//     //           ),
//     //         ),
//     //       );
//     //     },
//     //     child: Text('Go to Admin\'s Dashboard'),
//     //   ),
//     // );
//   }

//   Widget userPage(DocumentSnapshot snapshot) {
//     var newHr = 10;
//     var newMin = 0;
//     var newSec = 0;
//     var y;
//     String nameuser = snapshot.data['Name'];
//     if (snapshot.data['Birthday'] == null) {
//       olddate = DateTime.now();
//     } else {
//       Timestamp t = snapshot.data['Birthday'];
//       var date = t.toDate();
//       olddate = date;
//     }

//     DateTime newdate = DateTime.now();
//     if (olddate.day < newdate.day) {
//       if (olddate.month < newdate.month) {
//         y = newdate.year + 1;
//       } else if (olddate.month == newdate.month) {
//         y = newdate.year + 1;
//       } else
//         y = newdate.year;
//     } else if (olddate.day == newdate.day) {
//       if (olddate.month < newdate.month) {
//         y = newdate.year + 1;
//       } else if (olddate.month == newdate.month) {
//         y = newdate.year;
//       } else
//         y = newdate.year;
//     } else if (olddate.day > newdate.day) {
//       if (olddate.month < newdate.month) {
//         y = newdate.year + 1;
//       } else if (olddate.month == newdate.month) {
//         y = newdate.year;
//       } else
//         y = newdate.year;
//     } else
//       y = newdate.year;

//     print(y);
//     print("in user page");

//     DateTime finaldate =
//         new DateTime(y, olddate.month, olddate.day, newHr, newMin, newSec);
//     Timer(Duration(seconds: 2), () {
//       print(DateFormat('dd/MM/yyyy/H:m:s').format(finaldate));
//       // if (snapshot.data['DOB'] != " ") {
//       //   _showNotification(finaldate, nameuser);
//       // }
//       // if (DateFormat('dd/MM/yyyy').format(DateTime.now()) ==
//       //     snapshot.data['DOB']) {

//       // }
//       // 5s over, navigate to a new page
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => NormalUsers(
//             widget._user,
//             widget._googleSignIn,
//           ),
//         ),
//       );
//     });
//     return Container(
//         child: Center(
//             child: Text(
//       "Welcome to ISKCON PUNE",
//       style: TextStyle(
//           decoration: TextDecoration.none,
//           color: Colors.white,
//           fontSize: 22,
//           fontWeight: FontWeight.normal,
//           fontFeatures: null),
//     )));
//     // return Center
//     //   child: ButtonTheme(
//     //     minWidth: 300,
//     //     child: OutlineButton(
//     //       padding: EdgeInsets.symmetric(vertical: 15),
//     //       borderSide: BorderSide(color: Colors.white),
//     //       shape: StadiumBorder(),
//     //       textColor: Colors.white,
//     //       onPressed: () {
//     //         Navigator.push(
//     //           context,
//     //           MaterialPageRoute(
//     //             builder: (context) => NormalUsers(
//     //               widget._user,
//     //               widget._googleSignIn,
//     //             ),
//     //           ),
//     //         );
//     //       },
//     //       child: Text('Go to Dashboard'),
//     //     ),
//     //   ),
//     // child: Text(
//     //   "Welcome to Iskcon",
//     //   textScaleFactor: 1.5,
//     // ),
//     // );
//   }

//   Future selectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//     }
//   }

//   void initializing() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('ic_launcher');
//     var initializationSettingsIOS = IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     var initializationSettings = InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: selectNotification);
//   }

//   Future onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => CupertinoAlertDialog(
//         title: Text(title),
//         content: Text(body),
//         actions: [
//           CupertinoDialogAction(
//             isDefaultAction: true,
//             child: Text('Ok'),
//             onPressed: () async {
//               Navigator.of(context, rootNavigator: true).pop();
//               await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DailyDarshan(),
//                 ),
//               );
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> _showNotification(DateTime finaldate, String nameuser) async {
//     var scheduledNotificationDateTime = finaldate;

//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//             'ISKCON NVCC pune', 'ISKCON NVCC pune', 'channel description',
//             // importance: Importance.Max,
//             // priority: Priority.High,
//             // ticker: 'ticker',
//             styleInformation: BigTextStyleInformation('''Dear $nameuser,
//   We wish you a very Happy Birthday.We pray to Sri Sri Radha Vrindavanchandraji that they bestow their blessings upon you and your family profusely. Hare Krishna!
// Yours in service,
// ISKCON NVCC
// PUNE'''));
//     IOSNotificationDetails iOSPlatformChannelSpecifics =
//         IOSNotificationDetails();
//     NotificationDetails platformChannelSpecifics = NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.schedule(
//       0,
//       'Happy Birthday ' + nameuser,
//       'Dear ' + nameuser + ',',
//       scheduledNotificationDateTime,
//       platformChannelSpecifics,
//     );
//   }
// }
