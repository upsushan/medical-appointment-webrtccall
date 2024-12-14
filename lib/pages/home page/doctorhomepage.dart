import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medical/pages/videocall/ring_screen.dart';
import 'package:medical/pages/videocall/videocall.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/services/authservice.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selectedIndex = 0;

  late UserProvider userProvider;
  int currentActiveIndex = -1;



  @override
  Widget build(BuildContext context) {

    userProvider = Provider.of<UserProvider>(context);
    if(userProvider.patientAppointment==null || userProvider.patientAppointment!.isEmpty){
      userProvider.showAcceptedAppointment(true);
    }
    if(userProvider.patientAppointment_All==null || userProvider.patientAppointment_All!.isEmpty){
      userProvider.showAllAppointments(true);
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
                      Text('Serve your patients',
                          style: AppTextStyles()
                              .primaryStyle
                              .copyWith(fontSize: 20)),
                    ],
                  ),

                  // notification icon

                ],
              ),
            ),
            //search bar

            // my appoint ments
            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Accepted Appointments",
                    style: AppTextStyles().primaryStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),

            // appointments slider
            if(userProvider.patientAppointment!=null && userProvider.patientAppointment!.isNotEmpty)
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
                child: Center(child: Text("You have no accepted appointment yet.\n Please accept few patient requests to see them here.", style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,)),
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
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: ShapeDecoration(
                                          image: DecorationImage(
                                            image:
                                            AssetImage(AppImages.patient),
                                            fit: BoxFit.cover,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Color(0x33090909),
                                              blurRadius: 20,
                                              offset: Offset(0, 10),
                                              spreadRadius: 0,
                                            )
                                          ],
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
                                            userProvider.patientAppointment![itemIndex].clientName,
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
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RingScreen(clientID: userProvider.patientAppointment![itemIndex].clientId!,callerName: userProvider.patientAppointment![itemIndex]!.clientName, callerDetails: userProvider.patientAppointment![itemIndex].specialization!, callingTo:userProvider.patientAppointment![itemIndex]!.doctorName , )));
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
                    "New Appointments",
                    style: AppTextStyles().primaryStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            // categories list view

            // doctors list

            if(userProvider.patientAppointment_All != null)
              Expanded(
                child: userProvider.patientAppointment_All!.isNotEmpty ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: userProvider.patientAppointment_All!.length,
                    itemBuilder: (context, index) {
                      bool accepted = userProvider.patientAppointment_All![index].accepted;
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
                              ),
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
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(AppImages.patient),
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
                                            userProvider.patientAppointment_All![index].specialization!,
                                            style: GoogleFonts.sora(
                                              color: AppColors.mainTextColor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),

                                        // name
                                        Text(
                                          '${userProvider.patientAppointment_All![index].clientName!}',
                                          style: GoogleFonts.sora(
                                            color: AppColors.mainTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),


                                        Text(
                                          formatDateTime(userProvider.patientAppointment_All![index].date),
                                          style: GoogleFonts.sora(
                                            color: AppColors.secondaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),

                                //
                                // book now button
                                GestureDetector(
                                  onTap: ()async{
                                    if(currentActiveIndex == -1) {
                                      setState(() {
                                        currentActiveIndex = index;
                                      });
                                      await FirestoreProvider()
                                          .acceptAppointment(userProvider
                                          .patientAppointment_All![index]
                                          .appointmentId);
                                      setState(() {
                                        currentActiveIndex = -1;
                                      });
                                    }
                                  },
                                  child:  Opacity(
                                    opacity:  currentActiveIndex == index ? 0.5: 1,
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
                                                             currentActiveIndex == index ?  'Accepting..' : "Accept",
                                                              style: GoogleFonts.sora(
                                                                color: Colors.white,
                                                                fontSize: 11,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }) :
                Center(
                  child: Container(
                    width: 300,
                    child: Opacity(
                      opacity: 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.grey, size: 30,),
                          Text("You have not received any appointment requests at the moment.", textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),


           // Expanded(
              // child: ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     itemCount: 8,
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding:
              //             EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              //         child: Container(
              //           decoration: ShapeDecoration(
              //             color: Color(0xFFFFFFFD),
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(16),
              //             ),
              //             shadows: [
              //               BoxShadow(
              //                 color: Color(0x0C000000),
              //                 blurRadius: 15.30,
              //                 offset: Offset(0, 4),
              //                 spreadRadius: 0,
              //               )
              //             ],
              //           ),
              //           child: Padding(
              //             padding: EdgeInsets.symmetric(
              //                 horizontal: 10, vertical: 10),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 // profile images
              //
              //                 Row(
              //                   children: [
              //                     Container(
              //                       width: 50,
              //                       height: 50,
              //                       decoration: ShapeDecoration(
              //                         image: DecorationImage(
              //                           image: AssetImage(AppImages.profile),
              //                           fit: BoxFit.cover,
              //                         ),
              //                         shape: RoundedRectangleBorder(
              //                           borderRadius:
              //                               BorderRadius.circular(1000),
              //                         ),
              //                       ),
              //                     ),
              //
              //                     SizedBox(
              //                       width: 10,
              //                     ),
              //                     // details and reviews
              //                     // name
              //                     Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         // specialtity
              //                         Opacity(
              //                           opacity: 0.60,
              //                           child: Text(
              //                             'Heart',
              //                             style: GoogleFonts.sora(
              //                               color: AppColors.mainTextColor,
              //                               fontSize: 10,
              //                               fontWeight: FontWeight.w400,
              //                             ),
              //                           ),
              //                         ),
              //
              //                         // name
              //                         Text(
              //                           'Siri Doe',
              //                           style: GoogleFonts.sora(
              //                             color: AppColors.mainTextColor,
              //                             fontSize: 12,
              //                             fontWeight: FontWeight.w600,
              //                           ),
              //                         ),
              //
              //                         // reviews
              //                         Row(
              //                           crossAxisAlignment:
              //                               CrossAxisAlignment.center,
              //                           children: [
              //                             Text(
              //                               "Booked Time: 12:30",
              //                               style: GoogleFonts.sora(
              //                                 color: AppColors.secondaryColor,
              //                                 fontSize: 8,
              //                                 fontWeight: FontWeight.w400,
              //                               ),
              //                             )
              //                           ],
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //
              //                 //
              //                 // book now button
              //                 Container(
              //                   padding: const EdgeInsets.symmetric(
              //                       horizontal: 10, vertical: 8),
              //                   decoration: ShapeDecoration(
              //                     color: AppColors.primaryColor,
              //                     shape: RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(100),
              //                     ),
              //                   ),
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.min,
              //                     mainAxisAlignment: MainAxisAlignment.center,
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       Text(
              //                         'Accept Now',
              //                         style: GoogleFonts.sora(
              //                           color: Colors.white,
              //                           fontSize: 8,
              //                           fontWeight: FontWeight.w400,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
           // )
          ],
        ),
      ),
    );
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
