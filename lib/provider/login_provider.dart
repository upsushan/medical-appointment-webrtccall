
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical/services/authservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController _userEmail = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _passwordconfirm = new TextEditingController();
  late String _emailLoginStatus = "null";
  bool _loginWithGoogle = false;
  bool _loginWithApple = false;
  bool _loginWithEmail = false;

  TextEditingController get userEmail => _userEmail;
  TextEditingController get password => _password;
  TextEditingController get passwordconfirm => _passwordconfirm;
  bool get loginWithGoogle => _loginWithGoogle;
  bool get loginWithApple => _loginWithApple;
  bool get loginWithEmail => _loginWithEmail;
  String get emailLoginStatus => _emailLoginStatus;

  void emailLogin() async {
    _loginWithEmail = true;
    notifyListeners();
    if (_userEmail.text.isNotEmpty && _password.text.isNotEmpty) {
      String useremail = _userEmail.text;
      String password = _password.text;
      String? result = await AuthService.loginWithEmail(
          userEmail: useremail, password: password);
      _emailLoginStatus = result ?? "null";
      _loginWithEmail = false;
      notifyListeners();
      if(_emailLoginStatus == "INVALID_LOGIN_CREDENTIALS"){
        Fluttertoast.showToast(msg: "The Email and Password do not match");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter both email address and password");
    }
  }

  void guestLogin() async {
      String useremail = "stpdstn+2@gmail.com";
      String password = "password";
      String? result = await AuthService.loginWithEmail(
          userEmail: useremail, password: password);
      _emailLoginStatus = result ?? "null";
      notifyListeners();
      if(_emailLoginStatus == "INVALID_LOGIN_CREDENTIALS"){
        Fluttertoast.showToast(msg: "The Email and Password do not match");
      }

  }

  void emailLoginwithLocalAuth(String email,String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      String? result = await AuthService.loginWithEmail(
          userEmail: email, password: password);
      _emailLoginStatus = result ?? "null";
      notifyListeners();
      if(_emailLoginStatus == "INVALID_LOGIN_CREDENTIALS"){
        Fluttertoast.showToast(msg: "The Email and Password do not match");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter both email address and password");
    }
  }


  Future<String> emailSignup() async {
    _loginWithEmail = true;
    notifyListeners();
    if (_userEmail.text.isNotEmpty && _password.text.isNotEmpty) {
      if(_password.text == _passwordconfirm.text) {
        String useremail = _userEmail.text;
        String password = _password.text;
        String? result = await AuthService.signUpWithEmail(
            userEmail: useremail, password: password);
        _emailLoginStatus = result ?? "null";
        _loginWithEmail = false;
        _userEmail.text = "";
        _password.text = "";
        _passwordconfirm.text = "";
        notifyListeners();
        if(_emailLoginStatus == "new-user-loggedin"){
          Fluttertoast.showToast(msg: "Successfully Signed Up!");
        }
        return _emailLoginStatus;

      }else{
        Fluttertoast.showToast(msg: "Passwords do not match. Please check once.");
        return "null";
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please enter both email address and password");
      return "null";
    }
  }


  Future<bool> googleSignup() async {
    _loginWithGoogle = true;
    notifyListeners();
    String? email = await AuthService()
        .signInWithGoogle().whenComplete(() {
      _loginWithGoogle = false;
      notifyListeners();
    });


    if (email != null && email != "null") {
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("email-login", "verified");
      return true;
    }else{
      return false;
    }
  }

   Future<bool> signInWithApple() async {
    try {
       _loginWithApple = true;
       notifyListeners();
       final appleprovider = AppleAuthProvider();

      //shows native UI that asks user to show or hide their real email address
      appleprovider.addScope('email'); //this scope is required

      //pulls the user's full name from their Apple account
      appleprovider.addScope('name'); //this is not required

       var prefs = await SharedPreferences.getInstance();
       prefs.setString("email-login", "verified");

      final userCredential = await FirebaseAuth.instance.signInWithProvider(appleprovider).whenComplete(() {
        _loginWithApple = false;
        notifyListeners();
      });
      return true;

    }catch (e) {
      print(e);
      _loginWithApple = false;
      notifyListeners();
      return false;
    }
  }

}