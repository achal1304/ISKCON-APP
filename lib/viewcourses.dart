import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'crud.dart';
import 'customcardcourses.dart';

class ViewCourses extends StatefulWidget {
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;

  ViewCourses(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _ViewCoursesState createState() => _ViewCoursesState();
}

class _ViewCoursesState extends State<ViewCourses> {
  dynamic data;
  bool admincheck;

  Future<dynamic> getUserName() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(widget._user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        admincheck = snapshot.data['admin'];
      });
    });
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    bool admincheck = data['admin'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Join Courses',
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
      body: adminuserview(),
//    Container(
//        padding: const EdgeInsets.all(10.0),
//        child: StreamBuilder<QuerySnapshot>(
//          stream: Firestore.instance
//              .collection('Courses').where(
//              'Startdatetimestamp', isGreaterThanOrEqualTo: Timestamp.now())
//              .orderBy('Startdatetimestamp')
//              .snapshots(),
//          builder:
//              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
//            switch (snapshot.connectionState) {
//              case ConnectionState.waiting:
//                return Text('Loading...');
//              default:
//                return ListView(
//                  children:
//                  snapshot.data.documents.map((DocumentSnapshot document) {
//                    Timestamp daystart = document['Startdatetimestamp'];
//                    DateTime daystartts = daystart.toDate();
//                    int daysrem = daystartts
//                        .difference(DateTime.now())
//                        .inDays;
//                    int payamount = document['Course fees'];
//                    String daysremain = daysrem.toString();
//                    return Card(
//                      color: Color(0xffffffff),
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10))
//                      ),
//                      child: CustomCardCourses(
//                        title: document['Course Title'],
//                        description: document['Course Description'],
//                        //topic: document['Topic'],
//                        context: context,
//                        isAdmin1: admincheck,
//                        edate: document['End Date'],
//                        stime: document['Start Date'],
//                        url: document['URL'],
//                        type: document['Type'],
//                        venue: document['Venue'],
//                        startdatetimestamp: daysremain,
//                        useremail: widget._user.email,
//                        usercoursename: widget._user.displayName,
//                        regform: document['Registration Form'],
//                        payamount: payamount,
//                      ),
//                    );
//                  }).toList(),
//                );
//            }
//          },
//        ),
//      ),
    );
  }

  Widget adminuserview() {
    if (admincheck == true) {
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Courses')
              .orderBy('Startdatetimestamp')
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
                    Timestamp daystart = document['Startdatetimestamp'];
                    DateTime daystartts = daystart.toDate();
                    int daysrem = daystartts.difference(DateTime.now()).inDays;
                    int payamount = document['Course fees'];
                    String daysremain = daysrem.toString();
                    return Card(
                      color: Color(0xffffffff),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: CustomCardCourses(
                        title: document['Course Title'],
                        description: document['Course Description'],
                        //topic: document['Topic'],
                        context: context,
                        isAdmin1: admincheck,
                        edate: document['End Date'],
                        stime: document['Start Date'],
                        url: document['URL'],
                        type: document['Type'],
                        venue: document['Venue'],
                        startdatetimestamp: daysremain,
                        useremail: widget._user.email,
                        usercoursename: widget._user.displayName,
                        regform: document['Registration Form'],
                        payamount: payamount,
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      );
    } else
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('Courses')
              .where('Startdatetimestamp',
                  isGreaterThanOrEqualTo: Timestamp.now())
              .orderBy('Startdatetimestamp')
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
                    Timestamp daystart = document['Startdatetimestamp'];
                    DateTime daystartts = daystart.toDate();
                    int daysrem = daystartts.difference(DateTime.now()).inDays;
                    int payamount = document['Course fees'];
                    String daysremain = daysrem.toString();
                    return Card(
                      color: Color(0xffffffff),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: CustomCardCourses(
                        title: document['Course Title'],
                        description: document['Course Description'],
                        //topic: document['Topic'],
                        context: context,
                        isAdmin1: admincheck,
                        edate: document['End Date'],
                        stime: document['Start Date'],
                        url: document['URL'],
                        type: document['Type'],
                        venue: document['Venue'],
                        startdatetimestamp: daysremain,
                        useremail: widget._user.email,
                        usercoursename: widget._user.displayName,
                        regform: document['Registration Form'],
                        payamount: payamount,
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ),
      );
  }
}
