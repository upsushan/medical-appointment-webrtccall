import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:medical/provider/firestore_provider.dart';
import 'package:medical/provider/user_provider.dart';
import 'package:medical/utils/colors.dart';
import 'package:medical/utils/icons.dart';
import 'package:medical/utils/images.dart';
import 'package:medical/widgets/textStyles.dart';
import 'package:provider/provider.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  int currentActiveIndex = -1;
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    if(userProvider.patientAppointment==null || userProvider.patientAppointment!.isEmpty){
      userProvider.showAcceptedAppointment(true);
    }
    if(userProvider.patientAppointment_All==null || userProvider.patientAppointment_All!.isEmpty){
      userProvider.showAllAppointments(true);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 246, 254),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "New Appointments (All)",
                    style: AppTextStyles().primaryStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),

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
                                          image: AssetImage(AppImages.profile),
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
