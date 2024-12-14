import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical/helpers/auth_function.dart';
import 'package:medical/pages/auth/signupScreen.dart';
import 'package:medical/provider/login_provider.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';
import 'package:medical/widgets/buttonStyles.dart';
import 'package:medical/widgets/textFields.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late LoginProvider loginProvider;
  @override
  Widget build(BuildContext context) {

    loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(top:5),
          child: ListView(
            children: [
          // top welcome text
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Welcome back',
                  style: AppTextStyles().primaryStyle,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Select your preferred login method',
                    style: AppTextStyles().secondaryStyle),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  isPassword: false,
                  label: 'Email',
                  controller: loginProvider.userEmail,
                  hintText: 'Enter your email',
                  suffixIcon: SvgPicture.asset(AppIcons.email),
                  obscureText: false,
                ),
              ),

          // password field
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  isPassword: true,
                  label: 'Password',
                  controller: loginProvider.password,
                  hintText: 'Enter your password',
                  suffixIcon: SvgPicture.asset(AppIcons.eyeopen),
                  obscureText: false,
                ),
              ),
          // end password
              SizedBox(
                height: 15,
              ),

              // forgot password
              GestureDetector(
                onTap: ()async{
                  if(loginProvider.userEmail.text!="") {
                   await AuthService().forgotPassword(email: loginProvider.userEmail.text);
                   Fluttertoast.showToast(msg: "Mail sent to ${loginProvider.userEmail.text} to reset password.");
                  }else{
                    Fluttertoast.showToast(msg: "Please enter your email address in email field above.");
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      GestureDetector(
                        onTap: (){
                          loginProvider.guestLogin();
                        },
                        child: Text(
                          'Login as Guest',
                          style: GoogleFonts.sora(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      Text(
                        'Forgot password?',
                        style: GoogleFonts.sora(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),




                    ],
                  ),
                ),
              ),

          // login button
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MainButton(
                  text: "Log In",
                  onPressed: () {
                    loginProvider.emailLogin();
                  },
                ),
              ),

          // login with
              SizedBox(
                height: 20,
              ),

          // seperator

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 0.5,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Or Log In With',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sora(
                        color: AppColors.secondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        height: 0.5,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20,
              ),

          // login with biometric



          // login with face id
              SizedBox(
                height: 15,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? biometricsSetup = prefs.getString("biometrics");
                    if(biometricsSetup == null){
                      Fluttertoast.showToast(msg: "You need to setup biometrics after login.");
                    }else {
                      bool biometricAvailable = await LocalAuthService().canCheckBiometrics();
                      if(biometricAvailable) {
                        bool authenticated =  await LocalAuthService().authenticate();
                        if(authenticated){
                          String email = prefs.getString("email") ?? "";
                          String pass = prefs.getString("pass") ?? "";
                          loginProvider.emailLoginwithLocalAuth(email,pass);
                        }
                      }else{
                        Fluttertoast.showToast(msg: "You don't have any biometrics setup in your device.");
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 1,
                        )),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Platform.isAndroid ? AppIcons.fingerprint : AppIcons.faceid,
                          height: 50,
                          color: AppColors.primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Platform.isAndroid ? 'Login with Biometrics':'Face ID Login',
                              style: GoogleFonts.sora(
                                color: AppColors.mainTextColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // subtitle
                            Text(
                              'Securely authenticate your\nidentity using your Face .',
                              style: GoogleFonts.sora(
                                color: AppColors.secondaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

          // don't have an account
              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: GoogleFonts.sora(
                        color: AppColors.mainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                  GestureDetector(
                    onTap: () {
                      loginProvider.password.text = "";
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(" Sign Up",
                        style: GoogleFonts.sora(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ],
              ),

              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        bottomSheet: Column(
          children: [],
        ),
    );
  }
}



// faceid

class FaceIdAuthPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity, // Adjust height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.faceid,
            height: 60,
            color: AppColors.primaryColor,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Log In With Face ID',
            style: GoogleFonts.sora(
              color: AppColors.mainTextColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Please put your phone infront of your face to log in.',
              textAlign: TextAlign.center,
              style: AppTextStyles().secondaryStyle,
            ),
          )
        ],
      ),
    );
  }
}

void showFaceIdAuthPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return FaceIdAuthPopup();
    },
  );
}
