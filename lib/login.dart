// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// //import 'package:font_awesome_flutter/fa_icon.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:random_color/random_color.dart';

// import 'homeL.dart';
// import 'crud.dart';
// import 'premium.dart';

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class Login extends StatefulWidget {
//   GoogleSignIn _googleSignIn;
//   FirebaseUser _user;

//   Login(FirebaseUser user, GoogleSignIn signIn) {
//     _user = user;
//     _googleSignIn = signIn;
//   }

//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   StreamSubscription<DocumentSnapshot> subscription;

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   String email;
//   String name;
//   bool prem;
//   AsyncSnapshot<DocumentSnapshot> snapshot1;
//   dynamic data;

//   //String _email, _pass;
//   //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// //  Future<dynamic> getUserProgress() async {
// //    final DocumentReference document =
// //        Firestore.instance.collection("users").document(widget._user.uid);
// //
// //    await document.get().then<dynamic>((DocumentSnapshot snapshot1) async {
// //      setState(() {
// //        data = snapshot1.data['admin'];
// //        prem = snapshot1.data['premium'];
// //        print("premmmmmmm************ = " + prem.toString());
// //      });
// //    });
// //  }

//   @override
//   void initState() {
// //    getUserProgress();
// //    addOnStart(data, prem);

//     super.initState();
//   }

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
//             // Color(0xffFDC830),
//             // Color(0xfffc4a1a)
//             _color1,
//             _color2
//           ],
//         ),
//       ),
//       child: Center(
//         child: ButtonTheme(
//           minWidth: 300,
//           child: OutlineButton(
//             shape: StadiumBorder(),
//             textColor: Colors.white,
//             borderSide: BorderSide(color: Colors.white),
//             onPressed: () {
//               onGoogleSignIn(context);
//             },
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 FaIcon(FontAwesomeIcons.googlePlusG),
//                 SizedBox(width: 10),
//                 Text('Login'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<FirebaseUser> _handleSignIn() async {
//     // hold the instance of the authenticated user
//     FirebaseUser user;
//     // flag to check whether we're signed in already
//     bool isSignedIn = await _googleSignIn.isSignedIn();
//     if (isSignedIn) {
//       // if so, return the current user
//       user = await _auth.currentUser();
//     } else {
//       final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;
//       // get the credentials to (access / id token)
//       // to sign in via Firebase Authentication
//       final AuthCredential credential = GoogleAuthProvider.getCredential(
//           accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
//       user = (await _auth.signInWithCredential(credential)).user;
//     }

//     return user;
//   }

//   void onGoogleSignIn(BuildContext context) async {
//     FirebaseUser user = await _handleSignIn();
//     Crud().getData().then(
//       (val) {
// //        prem = val.documents[user.uid].data["premium"];
//         if (val.documents.length > 0) {
//           print(val.documents[user.uid].data["admin"]);
//         } else {
//           print("Not Found");
//         }
//       },
//     );
//     final DocumentReference document =
//         Firestore.instance.collection("users").document(user.uid);

//     await document.get().then<dynamic>((DocumentSnapshot snapshot1) async {
//       setState(() {
//         prem = snapshot1.data['premium'];
//       });
//     });
//     print("Value of premiumm is ************ = " + prem.toString());

//     if (prem == false) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PremiumCode(
//             user,
//             _googleSignIn,
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => HomePageL(
//             user,
//             _googleSignIn,
//           ),
//         ),
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_color/random_color.dart';

import 'homeL.dart';
import 'crud.dart';
import 'premium.dart';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  GoogleSignIn _googleSignIn;
  FirebaseUser _user;

  Login(FirebaseUser user, GoogleSignIn signIn) {
    _user = user;
    _googleSignIn = signIn;
  }

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StreamSubscription<DocumentSnapshot> subscription;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String email;
  String name;
  bool prem;
  AsyncSnapshot<DocumentSnapshot> snapshot1;
  dynamic data;

  //String _email, _pass;
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  Future<dynamic> getUserProgress() async {
//    final DocumentReference document =
//        Firestore.instance.collection("users").document(widget._user.uid);
//
//    await document.get().then<dynamic>((DocumentSnapshot snapshot1) async {
//      setState(() {
//        data = snapshot1.data['admin'];
//        prem = snapshot1.data['premium'];
//        print("premmmmmmm************ = " + prem.toString());
//      });
//    });
//  }

  @override
  void initState() {
//    getUserProgress();
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: /*[Colors.orange.shade300, Colors.orange.shade800]*/ [
            // Color(0xffFDC830),
            // Color(0xfffc4a1a)
            _color1,
            _color2
          ],
        ),
      ),
      child: Center(
        child: ButtonTheme(
          minWidth: 300,
          child: OutlineButton(
            shape: StadiumBorder(),
            textColor: Colors.white,
            borderSide: BorderSide(color: Colors.white),
            onPressed: () {
              onGoogleSignIn(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FaIcon(FontAwesomeIcons.googlePlusG),
                SizedBox(width: 10),
                Text('Login'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    // hold the instance of the authenticated user
    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
//     Crud().getData().then(
//       (val) {
// //        prem = val.documents[user.uid].data["premium"];
//         if (val.documents.length > 0) {
//           print(val.documents[user.uid].data["admin"]);
//         } else {
//           print("Not Found");
//         }
//       },
//     );
/*
    final DocumentReference document =
        Firestore.instance.collection("users").document(user.uid);
    await document.get().then<dynamic>((DocumentSnapshot snapshot1) async {
      setState(() {
        prem = snapshot1.data['premium'];
      });
    });
    print("Value of premiumm is ************ = " + prem.toString());
    if (prem == false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PremiumCode(
            user,
            _googleSignIn,
          ),
        ),
      );
    } else {
      */
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePageL(
          user,
          _googleSignIn,
        ),
      ),
    );
  }
}
