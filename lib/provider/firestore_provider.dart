import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:medical/models/appointment_model.dart';
import 'package:medical/models/usermodel.dart';

class FirestoreProvider{
  static final _auth = FirebaseAuth.instance;
  static final _ref = FirebaseFirestore.instance;
  String? _uid = _auth.currentUser?.uid;
  late StreamSubscription userSubs;

   Future<bool> checkIfNewUser() async{
    print("The uid here is $_uid");
    bool newUser = false;
    final _userRef = _ref.collection("users").doc(_uid);
    final _userSnap = await _userRef.get();
    if (!_userSnap.exists) {
      newUser = true;
    }
    return newUser;
  }


   void addUserData(String fullname,String userType, String disease, String specialization,
      final Function()? onSuccess,
      final Function()? onError) async {
    try {
      final _userRef = _ref.collection("users").doc(_uid);
      final _appUser = LoginUser(
        uid: _userRef.id,
        email: _auth.currentUser!.email ?? "null",
        status: "Online",
        name: fullname,
        userType: userType,
        disease: disease,
        specialization: specialization,
        lastLogin: FieldValue.serverTimestamp(),
        callstatus: ""
      );

      await _userRef.set(_appUser.toJson());

      onSuccess?.call();
      debugPrint('Success: Creating new user');
    } catch (e) {
      debugPrint(e.toString());
      onError?.call();
      debugPrint('Error!!!:  Creating new user');
    }
  }


  void createNewAppointment(String doctorid,DateTime date, String doctorName, String clientName, String doctorimg, String specialization,
      final Function()? onSuccess,
      final Function()? onError) async {
    try {
      final _docRef = _ref.collection("appointment").doc();
      final _appUser = Appointment(
          clientId: _uid!,
          doctorId: doctorid,
          date: date,
          doctorName: doctorName,
          clientName: clientName,
          image: doctorimg,
          specialization: specialization,
          accepted: false,
          appointmentId:_docRef.id
      );

      await _docRef.set(_appUser.toJson());

      onSuccess?.call();
      debugPrint('Success: Creating new appointment');
    } catch (e) {
      debugPrint(e.toString());
      onError?.call();
      debugPrint('Error!!!:  Creating new appointment');
    }
  }


  Stream<List<Appointment>> getMyAppointments_patient(bool doctor) {

    DateTime now =  DateTime.now();
    DateTime today = now.subtract(Duration(hours: 1));
    DateTime nextmonth = now.add(Duration(days: 30));

    Query<Map<String, dynamic>> q = _ref.collection('appointment')
        .where(doctor ? "doctorId" :"clientId", isEqualTo:  _uid!)
        .where("accepted", isEqualTo:  true)
        .where("date", isGreaterThanOrEqualTo:  today)
        .where("date", isLessThanOrEqualTo: nextmonth);
    return q
        .orderBy("date", descending: false)
        .limit(5)
        .snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
             return snapshot.docs.map((doc) => Appointment.fromJson(doc.data())).toList();
          },
    );
  }



  Future<bool> acceptAppointment(String docid)async{
    final userDoc = _ref.collection('appointment').doc(docid);
    await userDoc.update({"accepted": true, }).whenComplete((){
      return true;
    }).onError((error, stackTrace){
      return false;
    });
    return false;
  }

  Stream<List<Appointment>> getAllofmyAppointments(bool doctor) {
    DateTime now =  DateTime.now();
    DateTime today = now.subtract(Duration(hours: 1));
    DateTime nextmonth = now.add(Duration(days: 30));

    Query<Map<String, dynamic>> q = _ref.collection('appointment')
        .where(doctor ? "doctorId":"clientId", isEqualTo:  _uid!);
    
    if(doctor){
      q = q.where("accepted", isEqualTo: false);
    }

    q =  q.where("date", isGreaterThanOrEqualTo:  today)
        .where("date", isLessThanOrEqualTo: nextmonth);

    return q
        .orderBy("date", descending: false)
        .limit(20)
        .snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map((doc) => Appointment.fromJson(doc.data())).toList();
      },
    );
  }


  Stream<List<LoginUser>> getAllDoctors() {
    Query<Map<String, dynamic>> q = _ref.collection('users')
        .where("callstatus", isEqualTo:  "")
         .where("usertype", isEqualTo:  "doctor");

    return q
        .orderBy("lastlogin", descending: true)
        .limit(15)
        .snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map((doc) => LoginUser.fromJson(doc.data())).toList();
      },
    );
  }

  Stream<List<LoginUser>> getDoctorsByCategory(String speacialization) {
    Query<Map<String, dynamic>> q = _ref.collection('users')
        .where("usertype", isEqualTo:  "doctor")
        .where("callstatus", isEqualTo:  "")
        .where("specialization", isEqualTo: speacialization);

    return q
        .orderBy("lastlogin", descending: true)
        .limit(15)
        .snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map((doc) => LoginUser.fromJson(doc.data())).toList();
      },
    );
  }

  UpdateUserLastOnline()async{
    final userDoc = _ref.collection('users').doc(_uid);
    userDoc.update({"lastlogin": FieldValue.serverTimestamp(), });
  }

  UpdateBeingCalledasFalse(final Function()? onSuccess )async{
    final userDoc = _ref.collection('users').doc(_uid);
    userDoc.update({"beingcalled": "false", "roomid":"" }).then((value) => onSuccess);
  }

  currentUserStatus(String status)async{
    final userDoc = _ref.collection('users').doc(_uid);
    if(status != "Online") {
      userDoc.update({"status": status,});
    }else{
      userDoc.update({"status": status,"lastlogin": FieldValue.serverTimestamp()});
    }
  }

  Stream<List<LoginUser>> getUser(String uid) {
    Query<Map<String, dynamic>> q = _ref.collection('users')
        .where("uid", isEqualTo: uid);
    return q.limit(1)
        .snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs.map((doc) => LoginUser.fromJson(doc.data())).toList();
      },
    );
  }

  // appUser from firebase
   LoginUser? _userFromFirebase(final DocumentSnapshot<Map<String, dynamic>> snap) {
    if(snap.data()!=null) {
      print('hello this is val');
      return LoginUser.fromJson(snap.data() ?? {});
    }else{
      return null;
    }
  }

  // stream of app user
  Stream<LoginUser?> get getLoginUser{
    return _ref
        .collection("users")
        .doc(_uid)
        .snapshots()
        .map(_userFromFirebase);
  }

  // stream of app user
  Stream<DocumentSnapshot<Map<String, dynamic>>> get getLoginUserr{
    return _ref
        .collection("users")
        .doc(_uid)
        .snapshots();
  }

   LoginUser? _userFromFirebasee(User? user) {
    _uid = user!.uid;
    print("User is changed $_uid");
    return user != null ? LoginUser(uid: user.uid) : null;
  }

  // stream of auth user
   Stream<LoginUser?> get authUser {
    return _auth.authStateChanges().map(_userFromFirebasee);
  }


  static Future<String> getspecs() async {
    String tokenval = "";
    String appuser = _auth.currentUser!.uid;
    final currentUser = await _auth.currentUser!;
    await currentUser.reload();
    final _firebaseMessaging = FirebaseMessaging.instance;
    final String? _token = kIsWeb ? await _firebaseMessaging.getToken(vapidKey: "BKuhrfXCNyY6QNOj_ECPxouIv6Wxn7p-MD3byCE25Qt_Lp6TUh-hafSHpffFMhTsAcf2yWj-TlbECyRpV71VMnk") :  await _firebaseMessaging.getToken();

    final  _ref = FirebaseFirestore.instance;
    final docRef = _ref.collection("users").doc(appuser).collection(
        "token").doc(appuser);
    await docRef.get().then((snapshot) {
      if (_token != null) {
        final tokendata = <String, String>{
          "token": _token,
        };

        if (snapshot.exists) {
          tokenval = snapshot.get("token").toString();
          print("TokenVal is Not null");
          if ((_token ?? "") != tokenval) {
            docRef.set(tokendata);
          }else{
            print("TokenVal is good");
          }
        } else {
          print("TokenVal is null");
          docRef.set(tokendata).then((value) => print("value set"));
        }
      }
    });
    return tokenval;
  }
  }

