import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medical/pages/appointmentpage/patientAppointment.dart';
import 'package:medical/pages/home%20page/patienthomepage.dart';
import 'package:medical/pages/others/patient_AppointmentRequest.dart';
import 'package:medical/pages/settings/settings.dart';
import 'package:medical/pages/videocall/ring_screen.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:provider/provider.dart';

class HomePatientt extends StatefulWidget {
  const HomePatientt({super.key});

  @override
  State<HomePatientt> createState() => _HomePatientState();
}

class _HomePatientState extends State<HomePatientt> {
  int _selectedIndex = 0;
  late UserProvider userProvider;
  String beingCalled = "";


  static const List<Widget> _widgetOptions = <Widget>[
    PatientHomePage(),
     MyAppointmentRequest(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    userProvider = Provider.of<UserProvider>(context);

    // Here we are listening to incoming calls and doing the necessary checks and navigation
    if(userProvider.currentUser!=null){
      if(userProvider.currentUser!.beingcalled!=null){
        if(beingCalled == ""){
          if(userProvider.currentUser!.beingcalled == "true"){
            FirestoreProvider().UpdateBeingCalledasFalse(
                    (){beingCalled = "false";}
            );
          }else{
            beingCalled = "false";
          }
        }else if(userProvider.currentUser!.beingcalled! != beingCalled){
          beingCalled = userProvider.currentUser!.beingcalled!;
          if(userProvider.currentUser!.beingcalled! == "true"){
            Future.delayed(const Duration(seconds: 1)).then((val) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RingScreen(roomId:userProvider.currentUser!.roomid! )));
            });
          }
        }
      }else{
        beingCalled = "false";
      }
    }

    return SafeArea(
      top: false,
        child: Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 254),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        height: 70,
        color: Color.fromARGB(0, 12, 195, 64),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.navColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: BottomNavigationBar(
                  landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                  useLegacyColorScheme: false,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 0,
                  backgroundColor: Color.fromARGB(0, 206, 14, 14),
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      backgroundColor: Colors.transparent,
                      icon: SvgPicture.asset(
                        AppIcons.home,
                        color: _selectedIndex == 0
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        AppIcons.appointment,
                        color: _selectedIndex == 1
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        AppIcons.settings,
                        color: _selectedIndex == 2
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
