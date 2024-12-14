import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medical/models/usermodel.dart';
import 'package:medical/pages/home%20page/doctorhomepage.dart';
import 'package:medical/pages/home%20page/patienthomepage.dart';
import 'package:medical/pages/home/doctorhome.dart';
import 'package:medical/pages/home/patienthome.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/widgets/buttonStyles.dart';
import 'package:medical/widgets/textFields.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpAsScreen extends StatefulWidget {
  const SignUpAsScreen({super.key});

  @override
  State<SignUpAsScreen> createState() => _SignUpAsScreenState();
}

class _SignUpAsScreenState extends State<SignUpAsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // for inkwell
  int _selectedIndex = 0;
  //

  String? selectedOptionD;
  String? selectedOptionP;

  late UserProvider userProvider;
  bool dataLoaded = false;
  bool detailsAdded = true;
  List<LoginUser> doctorsList = [];
  int firstCallVal = 0;
  bool firstLoad = false;
  bool newUser = false;
  String beingCalled = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this); // Change the length according to the number of tabs
  }

  @override
  Widget build(BuildContext context) {

    userProvider = Provider.of<UserProvider>(context);
    if(!dataLoaded){
      userProvider.getUser();
      dataLoaded = true;
    }

    return  userProvider.userisnull == 0 ? Scaffold(): userProvider.userisnull != 1? SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Sign Up',
                    style: AppTextStyles().primaryStyle,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  'Choose whether you are patient or doctor to continue using this app.',
                  style: AppTextStyles().secondaryStyle),
            ),
            SizedBox(
              height: 25,
            ),
            // ima a

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'I am a',
                    style: AppTextStyles().primaryStyle,
                  ),
                ],
              ),
            ),
// tab bar

            SizedBox(
              height: 15,
            ),

            TabBar(
              automaticIndicatorColorAdjustment: false,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(color: Colors.transparent),
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              labelStyle: GoogleFonts.sora(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              labelColor: Colors.white,
              controller: _tabController,
              tabs: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                      _tabController.animateTo(0);
                      userProvider.typeSelector(0);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0
                          ? AppColors.primaryColor
                          : AppColors.textFieldBgColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Doctor",
                            style: GoogleFonts.sora(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            AppIcons.doctor,
                            color: _selectedIndex == 0
                                ? AppColors.white
                                : AppColors.mainTextColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      _tabController.animateTo(1);
                      userProvider.typeSelector(1);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1
                          ? AppColors.primaryColor
                          : AppColors.textFieldBgColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Patient",
                            style: GoogleFonts.sora(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            AppIcons.capsule,
                            height: 20,
                            color: _selectedIndex == 1
                                ? AppColors.white
                                : AppColors.mainTextColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

// tab bar view
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // doctor fields
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container()
                      ),

// drop down selection
                      SizedBox(
                        height: 15,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextField(
                          isPassword: false,
                          label: 'Name',
                          controller: userProvider.userName,
                          hintText: 'Full Name',
                          suffixIcon: Icon(
                            Icons.person,
                            size: 24,
                            color: AppColors.secondaryColor,
                          ),
                          obscureText: false,
                        ),
                      ),

                      SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropDown(
                          label: "Speciality",
                          hintText: "Telepharmacy",
                          options: [
                                'Elderly Care',
                                'General Healthcare',
                                'TeleRehabilitation',
                                'Teledermatogist',
                                'Telepsychiatry'
                          ],
                          selectedOption: selectedOptionD,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOptionD = value;
                              userProvider.specialization.text = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

// patient

                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container()
                      ),

// drop down selection
                      SizedBox(
                        height: 15,
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextField(
                          isPassword: false,
                          label: 'Name',
                          controller: userProvider.userName,
                          hintText: 'Full Name',
                          suffixIcon: Icon(
                            Icons.person,
                            size: 24,
                            color: AppColors.secondaryColor,
                          ),
                          obscureText: false,
                        ),
                      ),

                      SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropDown(
                          label: "Disease",
                          hintText: "Typhoid",
                          options: [
                            'Respiratory Infections',
                                'Skin Conditions',
                                 'Mental health Disorders',
                                'Chronic Diseases Management',
                                'Gastrointestinal Disorders',
                          ],
                          selectedOption: selectedOptionP,
                          onChanged: (String? value) {
                            setState(() {
                              selectedOptionP = value;
                              userProvider.disease.text = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
//
// submit
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MainButton(
                text: "Submit",
                onPressed: () {

                  userProvider.saveUserDetails();


                  // if (_selectedIndex == 0) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => DoctorHome()),
                  //   );
                  // } else if (_selectedIndex == 1) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => HomePatient()),
                  //   );
                  // }
                },
              ),
            ),
//
            SizedBox(
              height: 50,
            ),

          ],
        ),
      ),
    ) : userProvider.doctorsList == null ? Scaffold() :  userProvider.currentUser!= null ?  userProvider.currentUser!.userType == "patient" ? HomePatientt() : DoctorHome() : Container();
  }
}
