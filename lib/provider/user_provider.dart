
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical/models/appointment_model.dart';
import 'package:medical/models/usermodel.dart';
import 'package:medical/provider/firestore_provider.dart';

//Used in homescreen and audio_call
class UserProvider with ChangeNotifier {
  TextEditingController _userName = new TextEditingController();
  TextEditingController _disease = new TextEditingController();
  TextEditingController _specialization = new TextEditingController();
  String _accountType = "doctor";
  bool _doctorsLoaded = false;
  int _userstatus = 0;
  List<LoginUser>? _doctorsList;
  List<LoginUser>? _doctorsMainList;
  List<Appointment>? _patientAppointment = [];
  List<Appointment>? _patientAppointment_All = [];
  List<LoginUser>? _doctorsSearchList = [];
  LoginUser? _currentUser;

  TextEditingController get userName => _userName;
  TextEditingController get disease => _disease;
  TextEditingController get specialization => _specialization;
  String get accountType => _accountType;
  LoginUser? get currentUser => _currentUser;
  bool get doctorsLoaded => _doctorsLoaded;
  int get userisnull => _userstatus;
  List<LoginUser>? get doctorsList => _doctorsList;
  List<LoginUser>? get doctorsMainList => _doctorsMainList;
  List<Appointment>? get patientAppointment => _patientAppointment;
  List<Appointment>? get patientAppointment_All => _patientAppointment_All;
  List<LoginUser>? get doctorsSearchList => _doctorsSearchList;

  late  StreamSubscription<List<LoginUser>>  _doctorsSubscription;
  late  StreamSubscription<List<Appointment>>  _patientsAppointment;
  late  StreamSubscription<List<Appointment>>  _patientsAllAppointment;
  late StreamSubscription  _loginSubscription;

  void typeSelector(int btn){
    if(btn == 0){
      _accountType = "doctor";
    }else{
      _accountType = "patient";
    }
    notifyListeners();
  }

  //Saving the user details after signup
  void saveUserDetails(){
    if(_accountType!="null" && _userName.text !="" ){
      if((_accountType=="doctor" && _specialization.text !="") || (_accountType=="patient" && _disease.text !="")){
        FirestoreProvider().addUserData(_userName.text,_accountType, _disease.text, _specialization.text,
          (){
          Fluttertoast.showToast(msg: "Data Added Successfully");
         //
        }, (){
          Fluttertoast.showToast(msg: "Sorry, there was an issue. Please try again later.");
        });
      }else{
        Fluttertoast.showToast(msg: "Please add your details");
      }
    }else{
      Fluttertoast.showToast(msg: "Please add your details");
    }
  }

  void getUser(){
    //_userStatus is used to check if the user is new or not.
    if(_currentUser==null){
      _loginSubscription =
          FirestoreProvider().getLoginUser.listen((mainUser) {

           if(mainUser!=null){
              _currentUser = mainUser;
             _userstatus = 1;
             notifyListeners();
           }
           if(_userstatus == 0){
             _userstatus = 2;
             notifyListeners();
           }
            _doctorsLoaded = true;
            _doctorsSubscription.cancel();
            if (_currentUser != null)
              getAllDoctors(_currentUser!.userType == "doctor" ? "patient" : "doctor");
          });
    }
  }

  void getAllDoctors(String type){
    _doctorsSubscription =
        FirestoreProvider().getAllDoctors().listen((doctorsList) {
          _doctorsList = doctorsList;
          _doctorsMainList = _doctorsList;
          notifyListeners();
          // Notify listeners when the user data changes
        });
  }

  void getDoctorsByCategory(String category){
    _doctorsSubscription =
        FirestoreProvider().getDoctorsByCategory(category).listen((doctorsList) {
          _doctorsList = doctorsList;
          notifyListeners();
          // Notify listeners when the user data changes
        });
  }

  UserProvider() {
    _doctorsSubscription =
        FirestoreProvider().getAllDoctors().listen((doctorsList) {
          _doctorsList = doctorsList;
          notifyListeners();
         // Notify listeners when the user data changes
        });
  }

  void showAcceptedAppointment(bool doctor){
    if(_patientAppointment!=null) {
      _patientAppointment!.clear();
    }
    _patientsAppointment =
        FirestoreProvider().getMyAppointments_patient(doctor).listen((all_appointments) {
          _patientAppointment = all_appointments;
          notifyListeners();
          // Notify listeners when the user data changes
        });
  }

  void showAllAppointments(bool doctor){
    if(_patientAppointment_All!=null) {
      _patientAppointment_All!.clear();
    }
    _patientsAllAppointment =
        FirestoreProvider().getAllofmyAppointments(doctor).listen((all_appointments) {

          _patientAppointment_All = all_appointments;
          notifyListeners();
          // Notify listeners when the user data changes
        });
  }

  void searchDoctors(String keyword) {
    if(_doctorsSearchList!=null) {
      print("new notify cleared");
      _doctorsSearchList!.clear();
    }
    _doctorsSubscription =
        FirestoreProvider().getAllDoctors().listen((doctorsList) {
          var list = doctorsList;
          for(int i=0;i<list.length;i++){

            if(list[i].name!.toLowerCase().contains(keyword.toLowerCase())){

              _doctorsSearchList!.add(list[i]);
              print("testing ${list[i].name} ${_doctorsSearchList!.length}");
            }
          }
          notifyListeners();
          print("notified ${_doctorsSearchList!.length}");
          // Notify listeners when the user data changes
        });
  }

   signout() async {
     await _loginSubscription.cancel();
     await _doctorsSubscription.cancel();
    _doctorsList?.clear();
    _currentUser = null;
  }

  deleteUser() async {
    await _loginSubscription.cancel();
    await _doctorsSubscription.cancel();
    _doctorsList?.clear();
    _currentUser = null;
  }

  @override
  void dispose() async{
    await _loginSubscription.cancel();
    await _doctorsSubscription.cancel();
    await _patientsAppointment.cancel();
    await _patientsAllAppointment.cancel();
    super.dispose();
  }


}

