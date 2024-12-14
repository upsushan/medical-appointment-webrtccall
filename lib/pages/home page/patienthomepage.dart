import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medical/pages/appointmentpage/patientAppointment.dart';
import 'package:medical/pages/home%20page/patient_searchdoctor.dart';
import 'package:medical/pages/videocall/ring_screen.dart';
import 'package:medical/pages/videocall/videocall.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});
  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  int _selectedIndex = 0;
  late UserProvider userProvider;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    userProvider = Provider.of<UserProvider>(context);
    if(userProvider.patientAppointment==null || userProvider.patientAppointment!.isEmpty){
      userProvider.showAcceptedAppointment(false);
    }


    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 246, 254),
      body: Container(
        padding: EdgeInsets.only(top: 45),
        child: Column(
          children: [
            // top
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HI, ${userProvider.currentUser!.name}',
                          style: AppTextStyles()
                              .secondaryStyle
                              .copyWith(fontSize: 12)),
                      Text('Find your specialist',
                          style: AppTextStyles()
                              .primaryStyle
                              .copyWith(fontSize: 20)),
                    ],
                  ),


                ],
              ),
            ),
            //search bar
            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.textFieldBgColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextField(
                          controller: controller,
                          style: AppTextStyles().hintStyle,
                          decoration: InputDecoration(
                              isDense: true,
                              hintText: "Search doctors",
                              hintStyle: AppTextStyles()
                                  .hintStyle
                                  .copyWith(color: AppColors.secondaryColor),
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                    ),
                    // filter icon
                    GestureDetector(
                      onTap: (){
                        if(controller.text!="") {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      PatientSearchDoctor(
                                        keyword: controller.text,)));
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // my appoint ments
            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "My Appointments",
                    style: AppTextStyles().primaryStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),


            if(userProvider.patientAppointment!=null && userProvider.patientAppointment!.isNotEmpty)
            // appointments slider
            SizedBox(
              height: 15,
            ),


            if(userProvider.patientAppointment==null || userProvider.patientAppointment!.isEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.textFieldBgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Center(child: Text("You have no accepted appointment yet.\n Only appointments accepted by doctors will be shown here.", style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,)),
            ),


            if(userProvider.patientAppointment!=null && userProvider.patientAppointment!.isNotEmpty)
            Container(
              height: 160,
              margin: EdgeInsets.only(bottom: 10),
              child: CarouselSlider.builder(
                itemCount: userProvider.patientAppointment!.length,
                itemBuilder: (BuildContext context, int itemIndex,
                        int pageViewIndex) {
                  String calltime = formatDateTime(userProvider.patientAppointment![itemIndex].date);
                    return Container(
                    decoration: ShapeDecoration(
                    color: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    ),
                    ),
                    child: Column(
                    children: [
                // space
                    SizedBox(
                    height: 15,
                    ),

                    // details row
                    Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                    // profile image
                    Row(
                    children: [
                      urlImage(userProvider.patientAppointment![itemIndex].doctorId) != "null" ?
                      SizedBox(
                        height:50,
                        width: 50,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            clipBehavior: Clip.hardEdge,
                            child: CachedNetworkImage(imageUrl:   urlImage(userProvider.patientAppointment![itemIndex].doctorId))),
                      )
                          : Container(
                        width: 50,
                        height: 50,
                        decoration: ShapeDecoration(
                          image:  DecorationImage(
                            image: AssetImage(AppImages.doctor),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(1000),
                          ),
                        ),
                      ),

                      SizedBox(
                    width: 8,
                    ),
                    // name and description

                    Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                    // name
                    Text(
                    userProvider.patientAppointment![itemIndex].doctorName,
                    style: GoogleFonts.sora(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    ),
                    ),
                    // speciality
                    Opacity(
                    opacity: 0.60,
                    child: Text(
                    userProvider.patientAppointment![itemIndex].specialization,
                    style: GoogleFonts.sora(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    ),
                    ),
                    )
                    ],
                    ),
                    ],
                    ),

                    // video call
                      if(calltime!="Call Now")
                    GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(100)),
                    padding: EdgeInsets.all(6),
                    child: SvgPicture.asset(
                    AppIcons.videocall,
                    height: 24,
                    ),
                    ),
                    ),
                    ],
                    ),
                    ),

                // schedule time
                    SizedBox(
                    height: 15,
                    ),

                    GestureDetector(
                      onTap: (){
                        if(calltime=="Call Now" ) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RingScreen(clientID: userProvider.patientAppointment![itemIndex].doctorId!,callerName: userProvider.patientAppointment![itemIndex]!.doctorName, callerDetails: userProvider.patientAppointment![itemIndex].specialization!, callingTo:userProvider.patientAppointment![itemIndex]!.clientName , )));

                        }
                      },
                      child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                      decoration: BoxDecoration(
                      color: calltime!="Call Now" ? Color(0xFF5559E3) : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                      BoxShadow(
                      color: AppColors.primaryColor
                          .withOpacity(0.25),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                      spreadRadius: 0,
                      )
                      ],
                      ),
                      padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      SvgPicture.asset(calltime!="Call Now" ? AppIcons.time : AppIcons.videocall,width: 20,),
                      SizedBox(width: 10),
                      Text(
                        calltime,
                      style: GoogleFonts.sora(
                      color: calltime =="Call Now" ? AppColors.primaryColor : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      ),
                      )
                      ],
                      ),
                      ),
                      ),
                    ),
                    ],
                    ));
                    },
                options: CarouselOptions(
                  autoPlay: false,
                  reverse: false,
                  enlargeCenterPage: true,
                  viewportFraction: 0.85,
                  aspectRatio: 2.5,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeFactor: 0.2
                ),
              ),
            ),

            // doctors
            SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Doctors",
                    style: AppTextStyles().primaryStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            // categories list view
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [

                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                        userProvider.getAllDoctors("all");
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: _selectedIndex == 0
                              ? AppColors.primaryColor
                              : AppColors.textFieldBgColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              'All',
                              style: GoogleFonts.sora(
                                color: _selectedIndex == 0
                                    ? Colors.white
                                    : AppColors.mainTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )),
                  ),

                  SizedBox(
                    width: 10,
                  ),
            // teledermatology

                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                        userProvider.getDoctorsByCategory("Elderly Care");
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: _selectedIndex == 1
                              ? AppColors.primaryColor
                              : AppColors.textFieldBgColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              'Elderly Care',
                              style: GoogleFonts.sora(
                                color: _selectedIndex == 1
                                    ? Colors.white
                                    : AppColors.mainTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )),
                  ),

                  SizedBox(
                    width: 10,
                  ),
            // teledermatology

                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                        userProvider.getDoctorsByCategory("General Healthcare");

                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: _selectedIndex == 2
                              ? AppColors.primaryColor
                              : AppColors.textFieldBgColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              'General Healthcare',
                              style: GoogleFonts.sora(
                                color: _selectedIndex == 2
                                    ? Colors.white
                                    : AppColors.mainTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )),
                  ),
            // telepsychiatry

                  SizedBox(
                    width: 10,
                  ),
            // teledermatology

                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 3;
                        userProvider.getDoctorsByCategory("TeleRehabilitation");

                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: _selectedIndex == 3
                              ? AppColors.primaryColor
                              : AppColors.textFieldBgColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              'TeleRehabilitation',
                              style: GoogleFonts.sora(
                                color: _selectedIndex == 3
                                    ? Colors.white
                                    : AppColors.mainTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )),
                  ),

                  SizedBox(
                    width: 10,
                  ),
            // teledermatology

                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 4;
                        userProvider.getDoctorsByCategory("Teledermatologist");
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: _selectedIndex == 4
                              ? AppColors.primaryColor
                              : AppColors.textFieldBgColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              'Teledermatogist',
                              style: GoogleFonts.sora(
                                color: _selectedIndex == 4
                                    ? Colors.white
                                    : AppColors.mainTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )),
                  ),




                  SizedBox(
                    width: 10,
                  ),
            // teledermatology

                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 5;
                        userProvider.getDoctorsByCategory("Telepsychiatry");
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: _selectedIndex == 5
                              ? AppColors.primaryColor
                              : AppColors.textFieldBgColor,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            child: Text(
                              'Telepsychiatry',
                              style: GoogleFonts.sora(
                                color: _selectedIndex == 5
                                    ? Colors.white
                                    : AppColors.mainTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),

            // doctors list
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: userProvider.doctorsList!.length,
                  padding: EdgeInsets.only(top: 5),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Color(0xFFFFFFFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 15.30,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // profile images

                              Row(
                                children: [
                                  userProvider.doctorsList![index].imageurl!= null ?
                                  SizedBox(
                                    height:50,
                                    width: 50,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        clipBehavior: Clip.hardEdge,
                                        child: CachedNetworkImage(imageUrl:  userProvider.doctorsList![index].imageurl!)),
                                  )
                                      : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: ShapeDecoration(
                                      image:  DecorationImage(
                                        image: AssetImage(AppImages.doctor),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 10,
                                  ),
                                  // details and reviews
                                  // name
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // specialtity
                                      Opacity(
                                        opacity: 0.60,
                                        child: Text(
                                          userProvider.doctorsList![index].specialization!,
                                          style: GoogleFonts.sora(
                                            color: AppColors.mainTextColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),

                                      // name
                                      Text(
                                        'Dr. ${ userProvider.doctorsList![index].name!}',
                                        style: GoogleFonts.sora(
                                          color: AppColors.mainTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),

                              //
                              // book now button
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              PatientAppointmentScreen(
                                                doctor: userProvider.doctorsList![index],)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: ShapeDecoration(
                                    color: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Book Now',
                                        style: GoogleFonts.sora(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
  String urlImage(String DoctorId){
    var doctor  =  userProvider.doctorsMainList!.firstWhere((element) => element.uid == DoctorId);
    return doctor.imageurl != null ?  doctor.imageurl! : "null";
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day + 1) {
      // Tomorrow, 6:30 pm
      return "Tomorrow, "+DateFormat("h:mm a").format(dateTime);
    }else if (dateTime.year == now.year && dateTime.month == now.month && dateTime.day == now.day ) {
      // In 3 Hours
      Duration difference = dateTime.difference(now);
      if (difference.inHours >= 1) {
        return "In ${difference.inHours} ${difference.inHours == 1 ? "Hour" : "Hours"}";
      }else  if (difference.inMinutes >= 1){
        return "In ${difference.inMinutes} Minutes";
      }else{
        return "Call Now";
      }
    } else  {
      // 14th May, 6:30 PM
      return DateFormat("d MMM, h:mm a").format(dateTime);
    }
  }
}
