

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical/pages/auth/loginScreen.dart';
import 'package:medical/pages/auth/signupAs.dart';
import 'package:medical/pages/home/doctorhome.dart';
import 'package:medical/pages/others/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical/models/usermodel.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/verify_email.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
   bool _loading = true;
  late SharedPreferences prefs;
  String? emailLogin;
  bool loaded = true;
  @override
  void initState() {
    super.initState();
    initializeState();

    if(_loading) {
      Future.delayed(const Duration(milliseconds: 2600), () {
        setState(() => _loading = false);
      });
    }
  }


  Future<void> initializeState() async {
    // if the user is already logged in then we have a sharedpreferences value stored for "email-login" user is verified or not.
    // So we dont need to run AuthService.checkIfEmailVerified() everytime
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loaded = true;
      emailLogin = prefs.getString('email-login');
    });
  }

    @override
  Widget build(BuildContext context) {
    //Here we are checking if the user is online/verified/offline and displaying respective screen
    return StreamBuilder<LoginUser?>(
      stream: FirestoreProvider().authUser,
      builder: (_, AsyncSnapshot<LoginUser?> snapshot) {

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return  _loading ? SplashScreen() : LogInScreen();
          } else {
            bool verificationRequired = false;
            if(loaded && emailLogin==null || (emailLogin!=null && emailLogin == "null")) {
              return FutureBuilder<bool?>(
                future: AuthService.checkIfEmailVerified(),
                builder: (BuildContext context,
                    AsyncSnapshot<bool?> verificationSnapshot) {
                  if (verificationSnapshot.connectionState ==
                      ConnectionState.done) {
                    User? currentUser =  FirebaseAuth.instance.currentUser;

                    if(currentUser!=null){
                      verificationRequired = currentUser.providerData[0].providerId == "password";
                    }

                    bool verified = verificationSnapshot.data ?? false;
                    print("Email verified is $verified");
                    if(verified) {
                      prefs.setString("email-login", "verified");
                    }
                    return _loading ? SplashScreen() : !verified && verificationRequired ? verifyEmail() : SignUpAsScreen();
                  } else {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            }else if(loaded){
              print("Its loaded $emailLogin");
              return _loading ? SplashScreen() : emailLogin == "verified" ? SignUpAsScreen() : verifyEmail();
            }else{
              return _loading ? SplashScreen() : Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Colors.orange,),
                ),
              );
            }
          }
        } else {
         if (snapshot.hasError) {
           print(snapshot.error);
        }
        return _loading ? SplashScreen() : Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.orange,),
            ),
          );
        }
      },
    );
  }
}
