import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:login/audio/audiofolders.dart';
import 'package:login/demo.dart';
import 'package:login/donate.dart';
import 'package:login/editprofile.dart';
import 'package:login/picker.dart';
import 'package:login/viewcourses.dart';
import 'package:login/viewvideo.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'feedback.dart';
// import 'package:login/picker.dart';

// import 'addevent.dart';
import 'aboutus.dart';
import 'audiolist.dart';
import 'contactus.dart';
import 'customCard.dart';
// import 'makeadmin.dart';
import 'message.dart';
import 'msg.dart';
import 'subscriptions.dart';
import 'foodcoupons.dart';

class NormalUsers extends StatefulWidget {
  bool visible = false;
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;
  NormalUsers(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _NormalUsersState createState() => _NormalUsersState();
}

class _NormalUsersState extends State<NormalUsers> {
  Timestamp t1Date = new Timestamp.now();
  Timestamp t2Date = new Timestamp.now();
  Timestamp t3Date = new Timestamp.now();
  Timestamp t4Date = new Timestamp.now();

  var arr = [false, false, false, false];
  List<Widget> list = new List<Widget>();
  dynamic data;

  Future<dynamic> getUserName() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(widget._user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController taskTitleInputController;
  TextEditingController taskDescripInputController;
  TextEditingController topicInputController;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // AndroidInitializationSettings androidInitializationSettings;
  // IOSInitializationSettings iosInitializationSettings;
  // InitializationSettings initializationSettings;
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  //final List<Message> messages = [];
  String tok;
  String data1;
  bool isuseradmin = true;

  @override
  void initState() {
    taskTitleInputController = TextEditingController();
    taskDescripInputController = TextEditingController();
    topicInputController = TextEditingController();
    // setState(() {
    //   tok = value;
    // });
    getUserName();

    // sendBirthdayNotification(tok, data1);

    _firebaseMessaging.subscribeToTopic('Birthday');

    super.initState();
    initializing();
    // showNotification();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    //_firebaseMessaging.subscribeToTopic('all');
    // sendBirthdayNotification();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //final notification = message['notification'];
        // setState(
        //   () {
        //     messages.add(
        //       Message(
        //         // title: notification['title'],
        //         // body: notification['body'],
        //         title: '${notification['title']}',
        //         body: '${notification['body']}',
        //       ),
        //     );
        //   },
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        // final notification = message['data'];
        // setState(() {
        //   messages.add(Message(
        //     title: '${notification['title']}',
        //     body: '${notification['body']}',
        //   ));
        // });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          elevation: 0.5,
          leading: IconButton(
            padding: EdgeInsets.only(top: 30),
            icon: Image(
              image: AssetImage('assets/drawericon2.png'),
              // color: Colors.black,
              height: 70,
              width: 70,
            ),
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
          ),

          // leading: IconButton(
          //   icon: Padding(
          //     padding: const EdgeInsets.only(top: 22),
          //     child: FaIcon(
          //       FontAwesomeIcons.gopuram,
          //       color: Colors.black,
          //     ),
          //   ),
          //   onPressed: () => _scaffoldKey.currentState.openDrawer(),
          // ),
          backgroundColor: Color(0xfffdfcfa),
          title: Padding(
            padding: const EdgeInsets.only(top: 34),
            child: Text(
              'Hare Krishna!',
              textScaleFactor: 1.7,
              style: GoogleFonts.courgette(
                textStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: 75,
              child: DrawerHeader(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Welcome " + data['Name'] + "!"),
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget._user.photoUrl),
                    )
                  ],
                ),
              ),
            ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.solidBell,
            //     size: 25.0,
            //   ),
            //   title: Text('Subscriptions'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => Subscriptions(
            //             //widget._user,
            //             //widget._googleSignIn,
            //             ),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.prayingHands,
                size: 23.0,
              ),
              title: Text('View Daily Darshan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Demo(
                        //widget._user,
                        //widget._googleSignIn,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.podcast,
                size: 28.0,
              ),
              title: Text('Hear Audios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioFoldersList(
                      isAdmin: false,
                      //widget._user,
                      //widget._googleSignIn,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideosPage(
                      isAdmin: false,
                    ),
                  ),
                );
              },
              leading: FaIcon(
                FontAwesomeIcons.youtube,
                size: 23.0,
              ),
              title: Text('Latest Video'),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.bookOpen,
                size: 28.0,
              ),
              title: Text('Join Courses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewCourses(
                      widget._user,
                      widget._googleSignIn,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.userEdit,
                size: 28.0,
              ),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      //isAdmin: false,
                      widget._user,
                      widget._googleSignIn,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.hamburger,
                size: 28.0,
              ),
              title: Text('Food Coupons'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodCoupon(
                      //isAdmin: false,
                      widget._user,
                      widget._googleSignIn,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Donate(
                        //widget._user,
                        //widget._googleSignIn,
                        ),
                  ),
                );
              },
              leading: FaIcon(
                FontAwesomeIcons.rupeeSign,
                size: 25.0,
              ),
              title: Text('Donate'),
            ),
            // ListTile(
            //   leading: FaIcon(
            //     FontAwesomeIcons.plus,
            //     size: 23.0,
            //   ),
            //   title: Text('Post Queries'),
            //   onTap: () {
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //     builder: (context) => PostQuery(
            //     //         widget._user,
            //     //         widget._googleSignIn,
            //     //         ),
            //     //   ),
            //     // );
            //   },
            // ),
            Divider(
              thickness: 0.5,
            ),

            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.solidEnvelope,
                size: 23.0,
              ),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactScreen(
                        //widget._user,
                        //widget._googleSignIn,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.infoCircle,
                size: 23.0,
              ),
              title: Text('About ISKCON'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUs(
                        //widget._user,
                        //widget._googleSignIn,
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                Icons.feedback,
                size: 23.0,
              ),
              title: Text('Feedback'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeedBack(
                      widget._user,
                      widget._googleSignIn,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: FaIcon(
                Icons.share,
                size: 23.0,
              ),
              title: Text('Share App'),
              onTap: () async {
                share();
              },
            ),

            Divider(
              thickness: 0.5,
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.signOutAlt,
                size: 23.0,
              ),
              title: Text('Logout'),
              onTap: () {
                widget._googleSignIn.signOut();
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('home'),
                );
              },
            ),
            Divider(
              thickness: 0.5,
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('notifications')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading...');
              default:
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return Card(
                      color: Color(0xffffffff),
                      child: CustomCard(
                        title: document['Title'],
                        description: document['Body'],
                        //topic: document['Topic'],
                        context: context,
                        isAdmin: false,
                        ndate: document['Date'],
                        stime: document['Time'],
                        url: document['URL'],
                        desc: document['Description'],
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      ),
    );
  }

  //       body: Container(
  //         child: StreamBuilder<DocumentSnapshot>(
  //             stream: Firestore.instance
  //                 .collection('users')
  //                 .document(widget._user.uid)
  //                 .snapshots(),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<DocumentSnapshot> snapshot) {
  //               if (snapshot.hasError) {
  //                 return Text('Error : ${snapshot.error}');
  //               } else if (snapshot.hasData) {
  //                 // t1Date = snapshot.data['subscribedT1At'];
  //                 t2Date = snapshot.data['subscribedT2At'];
  //                 t4Date = snapshot.data['subscribedT4At'];
  //                 t3Date = snapshot.data['subscribedT3At'];
  //                 List<bool> t = checksub(snapshot.data);
  //                 //  print(t.length);
  //                 print(t);
  //                 return showEvents(t, snapshot);
  //               }
  //               return LinearProgressIndicator();
  //             }),
  //       ));
  // }

  // List<bool> checksub(DocumentSnapshot snapshot) {
  //   //print(snapshot.data['t1']); z

  //   if (snapshot.data['t1'] == true) {
  //     arr[0] = true;
  //   } else
  //     arr[0] = false;

  //   if (snapshot.data['t2'] == true) {
  //     arr[1] = true;
  //   } else
  //     arr[1] = false;
  //   if (snapshot.data['t3'] == true) {
  //     arr[2] = true;
  //   } else
  //     arr[2] = false;
  //   if (snapshot.data['t4'] == true) {
  //     arr[3] = true;
  //   } else
  //     arr[3] = false;
  //   return arr;
  // }

  // Widget showEvents(List<bool> t, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //   return Column(
  //     children: <Widget>[
  //       if (t[0] == true) sss1(snapshot),
  //       if (t[1] == true) sss2(),
  //       if (t[2] == true) sss3(),
  //       if (t[3] == true) sss4(),
  //       if (t[0] == false && t[1] == false && t[2] == false && t[3] == false)
  //         Container(
  //           child: Text("No Topics Subscribed!"),
  //         )
  //     ],
  //   );
  //   // return Container(
  //   //     child: CustomScrollView(
  //   //   scrollDirection: Axis.vertical,
  //   //   slivers: <Widget>[
  //   //     SliverList(
  //   //       delegate: SliverChildListDelegate([if (t[0] == true) sss1()]),
  //   //     ),
  //   //     SliverList(
  //   //       delegate: SliverChildListDelegate(
  //   //         [if (t[1] == true) sss2()],
  //   //       ),
  //   //     ),
  //   //     SliverList(
  //   //       delegate: SliverChildListDelegate(
  //   //         [if (t[2] == true) sss3()],
  //   //       ),
  //   //     ),
  //   //     SliverList(
  //   //       delegate: SliverChildListDelegate(
  //   //         [if (t[3] == true) sss4()],
  //   //       ),
  //   //     ),
  //   //   ],
  //   // ));
  // }

  // Widget sss1(AsyncSnapshot<DocumentSnapshot> snapshot1) {
  //   return Expanded(
  //       child: Column(children: <Widget>[
  //     Container(
  //       child: Text("Topic T1"),
  //     ),
  //     Container(
  //       child: StreamBuilder<QuerySnapshot>(
  //         stream: Firestore.instance
  //             .collection('notifications')
  //             .where('Category', isEqualTo: 't1')
  //             .where('createdAt',
  //                 isGreaterThanOrEqualTo: snapshot1.data['subscribedT1At'])
  //             .orderBy('createdAt', descending: true)
  //             .snapshots(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (snapshot.hasError) return Text('Error: ${snapshot.error}');
  //           switch (snapshot.connectionState) {
  //             case ConnectionState.waiting:
  //               return Text('No Data yet');
  //             default:
  //               return Expanded(
  //                   child: ListView(
  //                 shrinkWrap: true,
  //                 children:
  //                     snapshot.data.documents.map((DocumentSnapshot document) {
  //                   return Card(
  //                     color: Color(0xffffffff),
  //                     child: CustomCard(
  //                       title: document['Title'],
  //                       description: document['Body'],
  //                       //topic: document['Topic'],
  //                       context: context,
  //                       isAdmin: false,
  //                       ndate: document['Date'],
  //                       stime: document['Time'],
  //                       url: document['URL'],
  //                       desc: document['Description'],
  //                     ),
  //                   );
  //                 }).toList(),
  //               ));
  //           }
  //         },
  //       ),
  //     )
  //   ]));
  // }

  // Widget sss2() {
  //   return Expanded(
  //       child: Column(children: <Widget>[
  //     Container(
  //       child: Text("Topic T2"),
  //     ),
  //     Container(
  //       child: StreamBuilder<QuerySnapshot>(
  //         stream: Firestore.instance
  //             .collection('notifications')
  //             .where('Category', isEqualTo: 't2')
  //             .where('createdAt', isGreaterThanOrEqualTo: t2Date)
  //             .orderBy('createdAt', descending: true)
  //             .snapshots(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (snapshot.hasError) return Text('Error: ${snapshot.error}');
  //           switch (snapshot.connectionState) {
  //             case ConnectionState.waiting:
  //               return Text('No Data yet');
  //             default:
  //               return Expanded(
  //                   child: ListView(
  //                 shrinkWrap: true,
  //                 children:
  //                     snapshot.data.documents.map((DocumentSnapshot document) {
  //                   return Card(
  //                     color: Color(0xffffffff),
  //                     child: CustomCard(
  //                       title: document['Title'],
  //                       description: document['Body'],
  //                       //topic: document['Topic'],
  //                       context: context,
  //                       isAdmin: false,
  //                       ndate: document['Date'],
  //                       stime: document['Time'],
  //                       url: document['URL'],
  //                       desc: document['Description'],
  //                     ),
  //                   );
  //                 }).toList(),
  //               ));
  //           }
  //         },
  //       ),
  //     )
  //   ]));
  // }

  // Widget sss3() {
  //   return Expanded(
  //       child: Column(children: <Widget>[
  //     Container(
  //       child: Text("Topic T3"),
  //     ),
  //     Container(
  //       child: StreamBuilder<QuerySnapshot>(
  //         stream: Firestore.instance
  //             .collection('notifications')
  //             .where('Category', isEqualTo: 't3')
  //             .where('createdAt', isGreaterThanOrEqualTo: t3Date)
  //             .orderBy('createdAt', descending: true)
  //             .snapshots(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (snapshot.hasError) return Text('Error: ${snapshot.error}');
  //           switch (snapshot.connectionState) {
  //             case ConnectionState.waiting:
  //               return Text('No Data yet');
  //             default:
  //               return Expanded(
  //                   child: ListView(
  //                 shrinkWrap: true,
  //                 children:
  //                     snapshot.data.documents.map((DocumentSnapshot document) {
  //                   return Card(
  //                     color: Color(0xffffffff),
  //                     child: CustomCard(
  //                       title: document['Title'],
  //                       description: document['Body'],
  //                       //topic: document['Topic'],
  //                       context: context,
  //                       isAdmin: false,
  //                       ndate: document['Date'],
  //                       stime: document['Time'],
  //                       url: document['URL'],
  //                       desc: document['Description'],
  //                     ),
  //                   );
  //                 }).toList(),
  //               ));
  //           }
  //         },
  //       ),
  //     )
  //   ]));
  // }

  // Widget sss4() {
  //   return Expanded(
  //       child: Column(children: <Widget>[
  //     Container(
  //       child: Text("Topic T4"),
  //     ),
  //     Container(
  //       child: StreamBuilder<QuerySnapshot>(
  //         stream: Firestore.instance
  //             .collection('notifications')
  //             .where('Category', isEqualTo: 't4')
  //             .where('createdAt', isGreaterThanOrEqualTo: t4Date)
  //             .orderBy('createdAt', descending: true)
  //             .snapshots(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (snapshot.hasError) return Text('Error: ${snapshot.error}');
  //           switch (snapshot.connectionState) {
  //             case ConnectionState.waiting:
  //               return Text('No Data yet');
  //             default:
  //               return Expanded(
  //                   child: ListView(
  //                 shrinkWrap: true,
  //                 children:
  //                     snapshot.data.documents.map((DocumentSnapshot document) {
  //                   return Card(
  //                     color: Color(0xffffffff),
  //                     child: CustomCard(
  //                       title: document['Title'],
  //                       description: document['Body'],
  //                       //topic: document['Topic'],
  //                       context: context,
  //                       isAdmin: false,
  //                       ndate: document['Date'],
  //                       stime: document['Time'],
  //                       url: document['URL'],
  //                       desc: document['Description'],
  //                     ),
  //                   );
  //                 }).toList(),
  //               ));
  //           }
  //         },
  //       ),
  //     )
  //   ]));
  // }

  Future sendNotification() async {
    final response = await Messaging.sendToAll(
      title: taskTitleInputController.text,
      body: taskDescripInputController.text,
      // fcmToken: fcmToken,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content:
              Text('[${response.statusCode}] Error message: ${response.body}'),
        ),
      );
    }
  }

  Future sendBirthdayNotification() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(widget._user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
    await _firebaseMessaging.getToken().then((token) {
      print("HERE is your Token:" + token);
      setState(() {
        tok = token;
        print("Here is you tone agian== " + tok);
      });
      // setState(() {
      //   tok = value;
      // });
    });
    print(DateFormat('dd/MM/yyyy').format(DateTime.now()));
    print(data['DOB']);
    print(tok);

    // print("Your DOB for birthday is :" + data1);

    // if (DateFormat('dd/MM/yyyy').format(DateTime.now()) == data['DOB']) {
    //   final response = await Messaging.sendTo(
    //       title: 'Happy Birthday ' + data['Name'], body: null, fcmToken: tok);
    //   if (response.statusCode != 200) {
    //     Scaffold.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //             '[${response.statusCode}] Error message: ${response.body}'),
    //       ),
    //     );
    //   }
    // }
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
        AndroidInitializationSettings('app_icon');
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

  // void showNotification() async {
  //   await _showNotification();
  // }

  // Future<void> _showNotification() async {
  //   var scheduledNotificationDateTime =
  //       DateTime.now().add(Duration(seconds: 5));
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //           'channel id', 'channel name', 'channel description');
  //   IOSNotificationDetails iOSPlatformChannelSpecifics =
  //       IOSNotificationDetails();
  //   NotificationDetails platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.schedule(
  //       0,
  //       'scheduled title',
  //       'scheduled body',
  //       scheduledNotificationDateTime,
  //       platformChannelSpecifics);
  // }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }
}
