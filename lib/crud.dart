import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

final db = Firestore.instance;

class Crud {
  FirebaseUser user;
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  // Future<void> addData(userData) async {
  //   if (isLoggedIn()) {
  //     // print('uid: ' + user.uid);
  //     Firestore.instance.collection('users').add(userData).catchError((e) {
  //       print(e);
  //     });
  //   } else {
  //     print('You need to be logged in');
  //   }
  // }
  // getData() async {
  //   return await Firestore.instance.collection('users').getDocuments();
  // }

  final String _collection = 'users';
  final Firestore _fireStore = Firestore.instance;

  getData() async {
    return await _fireStore.collection(_collection).getDocuments();
  }

  storeData(FirebaseUser user) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.setData({
        'Name': user.displayName,
        'Email': user.email,
        'admin': false,
        't1': false,
        'subscribedT1At': Timestamp.now(),
        'subscribedT2At': Timestamp.now(),
        'subscribedT3At': Timestamp.now(),
        'subscribedT4At': Timestamp.now(),
        't2': false,
        't3': false,
        't4': false,
        'uid': user.uid,
        'progress': 0.25,
        'progressPercent': "25%",
        'Gender': "",
        'Address': "Address",
        'DOB': " ",
        'ARR': [true, false, false, false]
      });
      print("instance created");
    });
  }

  storeData1(FirebaseUser user, dynamic data, bool prem) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.setData({
        'Name': user.displayName,
        'Email': user.email,
        'admin': data ?? false,
        't1': false,
        'subscribedT1At': Timestamp.now(),
        'subscribedT2At': Timestamp.now(),
        'subscribedT3At': Timestamp.now(),
        'subscribedT4At': Timestamp.now(),
        't2': false,
        't3': false,
        't4': false,
        'uid': user.uid,
        'progress': 0.25,
        'progressPercent': "25%",
        'Gender': "",
        'Address': "Address",
        'DOB': " ",
        'ARR': [true, false, false, false],
        'FoodCoupons': 24,
        'premium': prem
      });
      print("instance created");
    });
  }

  storeDataOfCouponsSignup(FirebaseUser user, dynamic data, bool prem) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({'admin': data ?? false, 'premium': prem});
      print("Coupon data created");
    });
  }

  makeAdmin(String name, String mail, String uid) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef
          .setData({'Name': name, 'Email': mail, 'admin': true, 'uid': uid});
      print("admin created");
    });
  }

  // removeAdmin(String name, String mail, String uid) async {
  //   DocumentReference documentRef =
  //       Firestore.instance.collection("users").document(uid);
  //   Firestore.instance.runTransaction((transaction) async {
  //     await documentRef
  //         .setData({'Name': name, 'Email': mail, 'admin': false, 'uid': uid});
  //     print("admin removed");
  //   });
  // }

  addEventData(String title, String body, String desc, String sdate,
      String stime, String category,
      {String url =
          "https://thelivenagpur.com/wp-content/uploads/2019/08/IMG-20190821-WA0031.jpg"}) async {
    String comb = title + ' : ' + body;
    DocumentReference documentRef =
        Firestore.instance.collection("notifications").document(desc);
    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.setData({
          'Title': title,
          'Body': body,
          //'Topic': topic,
          'Description': desc,
          'Date': sdate,
          'Time': stime,
          'Category': category,
          'URL': url,
          'createdAt': Timestamp.now(),
        });
        print("Notification Data added!");
      },
    );
  }

  addCourseData(
      String title,
      String desc,
      String sdate,
      String edate,
      String Type,
      String venue,
      String url,
      DateTime sd,
      var arr,
      int paymentamount) async {
    DocumentReference documentRef =
        Firestore.instance.collection("Courses").document(desc);
    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.setData({
          'Course Title': title,
          'Course Description': desc,
          'Start Date': sdate,
          'End Date': edate,
          'URL': url,
          'Startdatetimestamp': sd,
          'Type': Type,
          'Venue': venue,
          'Registration Form': arr,
          'Course fees': paymentamount
        });
        print("Course Data added!");
      },
    );
  }

  addRegistrationData(
      String desc, String em, String address, String contact, String name) {
    DocumentReference documentRef = Firestore.instance
        .collection("Courses")
        .document(desc)
        .collection("Registration")
        .document(em);
    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.setData({
          'Username': name,
          'Useremail': em,
          'Contact No.': contact,
          'Address': address
        });
        print("Registration Data added!");
      },
    );
  }

  addVideoUrl(
    String url,
    bool isLive,
    /*bool showIcon*/
  ) async {
    DocumentReference documentRef =
        Firestore.instance.collection("video").document("videoUrl");
    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.setData({
          'URL': url,
          'live': isLive,
          //'show': showIcon,
        });
        print("Youtube Video added!");
      },
    );
  }

  showIcon(bool isLive) async {
    DocumentReference documentRef =
        Firestore.instance.collection("video").document("videoUrl");
    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.setData({
          'live': isLive,
          //'show': showIcon,
        });
        print("Icon State Changed!");
      },
    );
  }

  updateT1Date(FirebaseUser user, Timestamp sdate) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'subscribedT1At': sdate,
      });
      print("subscribedT1Date Updated");
    });
  }

  updateT2Date(FirebaseUser user, Timestamp sdate) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'subscribedT2At': sdate,
      });
      // print("subscribedT1Date Updated");
    });
  }

  updateT3Date(FirebaseUser user, Timestamp s3date) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'subscribedT3At': s3date,
      });
      // print("subscribedT1Date Updated");
    });
  }

  updateT4Date(FirebaseUser user, Timestamp sdate) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'subscribedT4At': sdate,
      });
      // print("subscribedT1Date Updated");
    });
  }

  addFeedBack(String emailID, String fb) async {
    DocumentReference documentRef =
        Firestore.instance.collection("Feedbacks").document(emailID);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.setData({'EmailID': emailID, 'Feedback': fb});
    });
  }

  editEventData(String topic,
      {String title,
      String body,
      String sdate,
      String stime,
      String url}) async {
    DocumentReference documentRef =
        Firestore.instance.collection("notifications").document(topic);
    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.setData({
          'Title': title,
          if (body.isNotEmpty) 'Body': body,
          'Topic': topic,
          if (sdate != "Not set") 'Date': sdate,
          if (stime != "NOt set") 'Time': stime,
          if (url.isNotEmpty) 'URL': url,
        });
        print("Notification Data edited!");
      },
    );
  }

  deleteCourseData(String desc) {
    DocumentReference documentRef =
        Firestore.instance.collection("Courses").document(desc);

    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.delete();
        print("Course Data deleted!");
      },
    );
  }

  deleteData(String desc) {
    DocumentReference documentRef =
        Firestore.instance.collection("notifications").document(desc);

    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.delete();
        print("Notification Data deleted!");
      },
    );
  }

  deleteCouponData(String desc) {
    DocumentReference documentRef =
        Firestore.instance.collection("PremiumCoupons").document(desc);

    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.delete();
        print("Coupon Data deleted!");
      },
    );
  }

  deleteAudioData(String desc) {
    DocumentReference documentRef =
        Firestore.instance.collection("audio").document(desc);

    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef.delete();
        print("Audio Data deleted!");
      },
    );
  }

  addAudioUrl(String name, String url, String chosenfolder, var arr) async {
    DocumentReference documentRef =
        Firestore.instance.collection(chosenfolder).document(name);
    Firestore.instance.runTransaction(
      (transaction) async {
        await documentRef
            .setData({'Name': name, 'URL': url, 'searchedKey': arr});
        print("Audio URL added!");
      },
    );
  }

  updateName(FirebaseUser user, String name) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'Name': name,
        'Phone': user.phoneNumber,
      });
      print("Name Updated");
    });
  }

  updateCouponsAvail(FirebaseUser user, int couponsavail) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({'FoodCoupons': couponsavail});
      print("Name Updated");
    });
  }

  addFoodCoupons(FirebaseUser user, int breakfast, int lunch, int dinner,
      String date) async {
    DocumentReference documentRef = Firestore.instance
        .collection("users")
        .document(user.uid)
        .collection("Food Coupons")
        .document(date);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.setData({
        'Date': date,
        'Breakfast': breakfast,
        'Lunch': lunch,
        'Dinner': dinner
      });
      print("Name Updated");
    });
  }

  updateWish(FirebaseUser user, bool wish) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'Wish': wish,
      });
      print("Wish Updated");
    });
  }

  updateAddress(FirebaseUser user, String address) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'Address': address,
        'Phone': user.phoneNumber,
      });
      print("Address Updated");
    });
  }

  updateDOB(FirebaseUser user, String dob, Timestamp birthday) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'DOB': dob,
        'Birthday': birthday,
        'Phone': user.phoneNumber,
      });
      print("DOB Updated");
    });
  }

  updateArr(FirebaseUser user, var arr) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'ARR': arr,
        // 'Phone': user.phoneNumber,
      });
      print("Array Updated");
    });
  }

  updateArr1(String desc, var arr) async {
    DocumentReference documentRef =
        Firestore.instance.collection("Courses").document(desc);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.setData({
        'ARR': arr,
        // 'Phone': user.phoneNumber,
      });
      print("Array Updated");
    });
  }

  updateGender(FirebaseUser user, String gender) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'Gender': gender,
        'Phone': user.phoneNumber,
      });
      print("Gender Updated");
    });
  }

  updateProgress(FirebaseUser user, double progress) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'progress': progress,
      });
      print("progress Updated");
    });
  }

  updateProgressPercent(FirebaseUser user, String progresspercent) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        'progressPercent': progresspercent,
      });
      print("progress percent Updated");
    });
  }

  updateT1(FirebaseUser user, bool val) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        't1': val,
      });
      print("subscription t1 Updated");
    });
  }

  updateT2(FirebaseUser user, bool val) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        't2': val,
      });
      print("subscription t2 Updated");
    });
  }

  updateT3(FirebaseUser user, bool val) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        't3': val,
      });
      print("subscription t3 Updated");
    });
  }

  updateT4(FirebaseUser user, bool val) async {
    DocumentReference documentRef =
        Firestore.instance.collection("users").document(user.uid);
    Firestore.instance.runTransaction((transaction) async {
      await documentRef.updateData({
        't4': val,
      });
      print("subscription t4 Updated");
    });
  }
}
