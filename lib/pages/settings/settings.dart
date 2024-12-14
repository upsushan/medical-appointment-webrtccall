import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/helpers/auth_function.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/widgets/buttonStyles.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late UserProvider userProvider;

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    prefInitialized();
    super.initState();
  }

  void prefInitialized() async{
  prefs = await SharedPreferences.getInstance();

}


  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return  Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 55),
        child:    Column(
          children: [
            Text('Settings',
                style: AppTextStyles()
                    .primaryStyle
                    .copyWith(fontSize: 20)),


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
                onTap: () {
                  String? biometric =  prefs.getString('biometrics');
                  if(biometric==null) {
                    showFaceIdAuthPopup(context);
                  }else{
                    Fluttertoast.showToast(msg: "Biometrics has been setup already.");
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
                       Platform.isAndroid? AppIcons.fingerprint : AppIcons.faceid,
                        height: 50,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      // column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Platform.isAndroid?  'Easy Login Setup':'Face ID Setup',
                            style: GoogleFonts.sora(
                              color: AppColors.mainTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // subtitle
                          Text(
                            'Securely authenticate your\nidentity using your Biometrics .',
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



    // login with face id
            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  logoutPopupCaller(context);
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
                     Icon(Icons.logout, size:  40, color: AppColors.primaryColor,),
                      SizedBox(
                        width: 10,
                      ),
                      // column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Logout',
                            style: GoogleFonts.sora(
                              color: AppColors.mainTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // subtitle
                          Text(
                            'Login with email/password or \nBiometrics if already set up.',
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




            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  if(userProvider.currentUser!.email!="stpdstn+2@gmail.com") {
                    deletePopupCaller(context);
                  }else{
                    Fluttertoast.showToast(msg: "You cannot delete guest user");
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
                      Icon(Icons.logout, size:  40, color: AppColors.primaryColor,),
                      SizedBox(
                        width: 10,
                      ),
                      // column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete Account',
                            style: GoogleFonts.sora(
                              color: AppColors.mainTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // subtitle
                          Text(
                            'Delete your Account completely \n from the MediAppoint app',
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

          ],
        ),
      ),
    );
  }
}


// faceid

class LogoutPopup extends StatelessWidget {
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 200,
      width: double.infinity, // Adjust height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            'Logout of the App?',
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
              'You need to log in again to aceess your appointments.',
              textAlign: TextAlign.center,
              style: AppTextStyles().secondaryStyle,
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: MainButton(
              text: "Yes, Logout",
              onPressed: () async{
                await userProvider.signout();
                await Future.delayed(const Duration(seconds: 1));
                AuthService().signOut();
                Navigator.pop(context);
              },
            ),
          ),

          SizedBox(
            height: 15,
          ),

        ],
      ),
    );
  }
}

class DeletePopup extends StatelessWidget {
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 200,
      width: double.infinity, // Adjust height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            'Delete your Account?',
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
              'All of your information will be deleted, you need to create a new account to login again.',
              textAlign: TextAlign.center,
              style: AppTextStyles().secondaryStyle,
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: MainButton(
              text: "Yes, Delete",
              onPressed: () async{
                await userProvider.signout();
                await Future.delayed(const Duration(seconds: 1));
                AuthService().deleteUser();
                Navigator.pop(context);
              },
            ),
          ),

          SizedBox(
            height: 15,
          ),

        ],
      ),
    );
  }
}



void logoutPopupCaller(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return LogoutPopup();
    },
  );
}


void deletePopupCaller(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return DeletePopup();
    },
  );
}




// faceid

class FaceIdAuthPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: MainButton(
              text: "Setup Face ID Login",
              onPressed: () async{


                bool biometricAvailable = await LocalAuthService().canCheckBiometrics();
                if(biometricAvailable) {
                 bool authenticated =  await LocalAuthService().authenticate();
                 if(authenticated){
                   final SharedPreferences prefs = await SharedPreferences.getInstance();
                   await prefs.setString('biometrics', "yes");
                   Navigator.pop(context);
                   FaceIdSuccessPopup(context);
                 }
                }else{
                  Fluttertoast.showToast(msg: "You don't have any biometrics setup in your device.");
                }
              },
            ),
          ),
          SizedBox(
            height: 15,
          ),

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






class FaceIdSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity, // Adjust height as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 40, color: AppColors.primaryColor,),
          SizedBox(
            height: 15,
          ),
          Text(
            'Biometrics Linked',
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
              'Biometrics has been linked successfully. You can now login with your Face or Touch Id.',
              textAlign: TextAlign.center,
              style: AppTextStyles().secondaryStyle,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: MainButton(
              text: "Close",
              onPressed: () async{

                Navigator.pop(context);
              },
            ),
          ),

          SizedBox(
            height: 15,
          ),

        ],
      ),
    );
  }
}

void FaceIdSuccessPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return FaceIdSuccess();
    },
  );
}


