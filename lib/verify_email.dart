import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical/pages/auth/signupAs.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/widgets/buttonStyles.dart';
import 'package:medical/wrapper.dart';

class verifyEmail extends StatefulWidget {
  const verifyEmail({super.key});

  @override
  State<verifyEmail> createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {

  bool verified = false;

  @override
  void initState() {
    super.initState();

    //Sending verification email
    AuthService().verifyEmail();

    //Checking every 3 seconds if the email is verified. This will run only when the user is in this particular screen.
    Timer.periodic(Duration(seconds: 3), (Timer timer)async {
       verified = (await AuthService.checkIfEmailVerified())!;
       if(verified){
         timer.cancel();
         setState(() {});
       }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric( horizontal: 20),
        child:verified ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.primaryColor,size: 60,),
            SizedBox(height: 15,),
            Text("Successfully Verified", ),
            SizedBox(height: 5,),
            Text("Congratulations! You have been successfully verified!"),
            SizedBox(height: 10,),
            MainButton(text: "Continue",onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpAsScreen(),));
            },)],
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            CircularProgressIndicator(color: AppColors.primaryColor,),
            SizedBox(height: 15,),
            Text("Verify your E-mail", ),
            SizedBox(height: 5,),
            Text("We've sent you an email with a link. Open it in a browser and wait till you get verified message and return back to the app."),

          ],
        ),
      ),
    );
  }
}

