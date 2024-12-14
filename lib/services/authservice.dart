import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical/models/usermodel.dart';
import 'package:medical/provider/firestore_provider.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  Future<String?> signInWithGoogle() async {
    if(kIsWeb){
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try{
        final UserCredential userCredential = await _auth.signInWithPopup(authProvider);
        final newUser = await FirestoreProvider().checkIfNewUser();
        if (!newUser) {
          await storePref("verified");  //Storing for wrapper check.
          return "user_exists";
        }
        else {
          return userCredential.user!.email;
        }
      }catch(e){
        print('Error signing in with Google: $e');
        return null;
      }
    }else{
      try {
        // Trigger the Google Sign In process
        final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn()
            .signIn();
        if (googleSignInAccount == null) {
          // User canceled the Google Sign In process
          return "null";
        }
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        // Sign in to Firebase with the Google credentials
        final OAuthCredential googleAuthCredential = GoogleAuthProvider
            .credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(
            googleAuthCredential);

        final newUser = await FirestoreProvider().checkIfNewUser();
        if (!newUser) {
          await storePref("verified"); //Storing for wrapper check.
          return "user_exists";
        }
        else {
          return authResult.user!.email;
        }

      } catch (e) {
        print('Error signing in with Google: $e');
        return null;
      }
    }
  }


  static Future<String?> loginWithEmail(
      {required String userEmail,
        required String password}) async {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: userEmail, password: password);
          await checkIfEmailVerified();
          await storeCreds(userEmail,password);
          return "old-user-loggedin";
        } on FirebaseAuthException catch (e) {
          return e.code;
        }
      }

  Future forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }



  static Future<String?> signUpWithEmail(
      {required String userEmail,
        required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userEmail, password: password);
      await checkIfEmailVerified();  //We need to verify email here
      await storeCreds(userEmail,password);

      return "new-user-loggedin";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Sorry, this email already exists");
      }else{
        Fluttertoast.showToast(msg: e.message!);
      }
      return e.code;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

   static Future<bool?> checkIfEmailVerified()async{
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      bool verified =  _auth.currentUser!.emailVerified;
      await storePref(verified ? "verified" : "unverified");  //Storing for wrapper check.
      return verified;
    }catch (e){
      await storePref("unverified"); //Storing for wrapper check.
      return false;
    }
  }

  void verifyEmail(){
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }



  void signOut() async {
    try {
      String loginType = FirebaseAuth.instance.currentUser!.providerData[0].providerId;

      //We need to signout particular auth service along with _auth.signOut()
      if(loginType == "google.com"){
        await GoogleSignIn().signOut();
      }
      await storePref("null");   //Keeping user_verified as null so we can checkIfEmailVerified() when new user logs in.
      await _auth.signOut();
    } catch (e) {
      print("Couldn't Signout. Please try again later");
    }
  }


  void deleteUser() async {
    try {
      String loginType = FirebaseAuth.instance.currentUser!.providerData[0].providerId;

      //We need to signout particular auth service along with _auth.signOut()
      if(loginType == "google.com"){
        await GoogleSignIn().signOut();
      }
      await storePref("null");
      await _auth.currentUser!.delete();//Keeping user_verified as null so we can checkIfEmailVerified() when new user logs in.
      await _auth.signOut();

    } catch (e) {
      print("Couldn't Signout. Please try again later");
    }
  }




  static storePref(String val)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email-login', val);
  }



  static storeCreds(String email,password)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('pass', password);
  }

}
