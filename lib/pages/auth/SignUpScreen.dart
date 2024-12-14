import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medical/pages/auth/SignUpScreen.dart';
import 'package:medical/pages/auth/loginScreen.dart';
import 'package:medical/pages/auth/signupAs.dart';
import 'package:medical/pages/auth/signupScreen.dart';
import 'package:medical/provider/login_provider.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';
import 'package:medical/widgets/buttonStyles.dart';
import 'package:medical/widgets/textFields.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/wrapper.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late LoginProvider loginProvider;

  @override
  Widget build(BuildContext context) {
    loginProvider = Provider.of<LoginProvider>(context);

    return  Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 5),

          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Sign Up',
                  style: AppTextStyles().primaryStyle,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                    'Enter the details below to sign up as doctor and get started.',
                    style: AppTextStyles().secondaryStyle),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  isPassword: false,
                  controller: loginProvider.userEmail,
                  label: 'Email',
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
                  suffixIcon: Icon(
                    Icons.email,
                    size: 24,
                    color: AppColors.secondaryColor,
                  ),
                  obscureText: false,
                ),
              ),
          // end password

          // confirm password field
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomTextField(
                  isPassword: true,
                  controller: loginProvider.passwordconfirm,
                  label: 'Confirm Password',
                  hintText: 'Re-Enter your password',
                  suffixIcon: Icon(
                    Icons.email,
                    size: 24,
                    color: AppColors.secondaryColor,
                  ),
                  obscureText: false,
                ),
              ),

          // login button
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: MainButton(
                  text: "Sign Up",
                  onPressed: () async{
                    String response = await loginProvider.emailSignup();
                    if(response == "new-user-loggedin"){
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          Wrapper()), (Route<dynamic> route) => false);
                    }
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

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        bool signedIn = await loginProvider.googleSignup();
                        if(signedIn){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              Wrapper()), (Route<dynamic> route) => false);
                        }
                      },

                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.secondaryColor,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if(loginProvider.loginWithGoogle)
                              CircularProgressIndicator(color: AppColors.primaryColor,),

                              Opacity(
                                opacity: loginProvider.loginWithGoogle ? 0.5 : 1,
                                child: Image.asset(
                                  AppImages.google,
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20,),

                    GestureDetector(
                      onTap: ()async{
                       bool signedIn =  await loginProvider.signInWithApple();
                       if(signedIn){
                         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                             Wrapper()), (Route<dynamic> route) => false);
                       }
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.secondaryColor,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [

                           if(loginProvider.loginWithApple)
                          SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(color: AppColors.primaryColor, )),

                           Opacity(
                            opacity: loginProvider.loginWithApple ? 0.5 : 1,
                            child: Image.asset(
                                AppImages.apple,
                                height: 28,
                              ),
                            ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          // don't have an account
              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                      style: GoogleFonts.sora(
                        color: AppColors.mainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LogInScreen()));
                    },
                    child: Text(" Log In",
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
